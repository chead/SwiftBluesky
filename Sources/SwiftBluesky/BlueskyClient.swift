//
//  BlueskyClient.swift
//  
//
//  Created by Christopher Head on 7/28/23.
//

import Foundation
import SwiftATProto
import SwiftLexicon

public enum BlueskyClientError: Error {
    case invalidRequest
    case invalidResponse
    case unauthorized
    case unavailable
    case invalidLexicon
    case unknown

    init(atProtoHTTPClientError: ATProtoHTTPClientError) {
        switch(atProtoHTTPClientError) {
        case .badRequest:
            self = .invalidRequest

        case .unauthorized, .forbidden:
            self = .unauthorized

        case .notFound, .unavailable:
            self = .unavailable

        default:
            self = .unknown
        }
    }
}

@available(iOS 16.0, *)
public class BlueskyClient {
    private static func makeRequest<RequestBody: Encodable, ResponseBody: Decodable>(lexicon: String, host: URL, credentials: (accessToken: String, refreshToken: String), body: RequestBody?, parameters: [String : any Codable], retry: Bool = true) async throws -> Result<(body: ResponseBody, credentials: (accessToken: String, refreshToken: String)?), BlueskyClientError> {
        let requestLexicon = try JSONDecoder().decode(Lexicon.self,
                                                      from: try Data(contentsOf: Bundle.module.url(forResource: lexicon,
                                                                                                   withExtension: "json")!))

        var requestable: (any LexiconHTTPRequestable)?

        if let mainDef = requestLexicon.defs["main"] {
            switch mainDef {
            case .query(let lexiconQuery):
                requestable = lexiconQuery

            case .procedure(let lexiconProcedure):
                requestable = lexiconProcedure
                
            default:
                return .failure(.invalidRequest)
            }
        } else {
            return .failure(.invalidLexicon)
        }

        guard let requestable = requestable else {
            return .failure(.invalidRequest)
        }

        let request = try ATProtoHTTPRequest(host: host,
                                             nsid: requestLexicon.id,
                                             parameters: parameters,
                                             body: body,
                                             token: credentials.accessToken,
                                             requestable: requestable)

        let requestResult: Result<ResponseBody?, ATProtoHTTPClientError> = await ATProtoHTTPClient().make(request: request)

        switch requestResult {
        case .success(let getProfilesResponse):
            guard let getProfilesResponse = getProfilesResponse else { return .failure(.invalidResponse) }

            return .success((body: getProfilesResponse,
                             credentials: retry == false ? credentials : nil))

        case .failure(let error):
            switch(error) {
            case .badRequest:
                if retry == true {
                    switch(try await refreshSession(host: host, refreshToken: credentials.refreshToken)) {
                    case .success(let refreshSessionResponse):
                        return try await makeRequest(lexicon: lexicon,
                                                     host: host,
                                                     credentials: (refreshSessionResponse.accessJwt,
                                                                   refreshSessionResponse.refreshJwt),
                                                     body: body,
                                                     parameters: parameters,
                                                     retry: false)

                    case .failure(let error):
                        return .failure(error)
                    }
                } else {
                    return .failure(.unauthorized)
                }

            default:
                return .failure(BlueskyClientError(atProtoHTTPClientError: error))
            }
        }
    }

    public static func createSession(host: URL, identifier: String, password: String) async throws -> Result<ATProtoServerCreateSessionResponseBody, BlueskyClientError> {
        let createSessionLexicon = try JSONDecoder().decode(Lexicon.self,
                                                            from: try Data(contentsOf: Bundle.module.url(forResource: "com.atproto.server.createSession",
                                                                                                         withExtension: "json")!))

        if let mainDef = createSessionLexicon.defs["main"] {
            switch mainDef {
            case .procedure(let procedure):
                let createSessionRequestBody = ATProtoServerCreateSessionRequestBody(identifier: identifier, password: password)

                let createSessionRequest = try ATProtoHTTPRequest(host: host, 
                                                                  nsid: createSessionLexicon.id,
                                                                  parameters: [:],
                                                                  body: createSessionRequestBody,
                                                                  token: nil,
                                                                  requestable: procedure)

                let createSessionResult: Result<ATProtoServerCreateSessionResponseBody?, ATProtoHTTPClientError> = await ATProtoHTTPClient().make(request: createSessionRequest)

                switch createSessionResult {
                case .success(let createSessionResponse):
                    guard let createSessionResponse = createSessionResponse else { return .failure(.invalidResponse) }

                    return .success(createSessionResponse)
                
                case .failure(let error):
                    return .failure(BlueskyClientError(atProtoHTTPClientError: error))
                }

            default:
                return .failure(.invalidRequest)
            }
        }
        
        return .failure(.unknown)
    }

    public static func refreshSession(host: URL, refreshToken: String) async throws -> Result<ATProtoServerRefreshSessionResponseBody, BlueskyClientError> {
        let refreshSessionLexicon = try JSONDecoder().decode(Lexicon.self,
                                                             from: try Data(contentsOf: Bundle.module.url(forResource: "com.atproto.server.refreshSession",
                                                                                                          withExtension: "json")!))

        if let mainDef = refreshSessionLexicon.defs["main"] {
            switch mainDef {
            case .procedure(let procedure):
                let refreshSessionRequest = try ATProtoHTTPRequest(host: host,
                                                                   nsid: refreshSessionLexicon.id,
                                                                   parameters: [:],
                                                                   body: nil,
                                                                   token: refreshToken,
                                                                   requestable: procedure)

                let refreshSessionResult: Result<ATProtoServerRefreshSessionResponseBody?, ATProtoHTTPClientError> = await ATProtoHTTPClient().make(request: refreshSessionRequest)

                switch refreshSessionResult {
                case .success(let refreshSessionResponse):
                    guard let refreshSessionResponse = refreshSessionResponse else { return .failure(.invalidResponse) }

                    return .success(refreshSessionResponse)

                case .failure(let error):
                    return .failure(BlueskyClientError(atProtoHTTPClientError: error))
                }

            default:
                return .failure(.invalidRequest)
            }
        }

        return .failure(.unknown)
    }

    public static func getProfiles(host: URL, accessToken: String, refreshToken: String, actors: [String], retry: Bool = true) async throws -> Result<(body: BlueskyActorGetProfilesResponseBody, credentials: (accessToken: String, refreshToken: String)?), BlueskyClientError> {
        try await makeRequest(lexicon: "app.bsky.actor.getProfiles",
                              host: host,
                              credentials: (accessToken, refreshToken),
                              body: nil as String?,
                              parameters: ["actors" : actors])
    }

    public static func getAuthorFeed(host: URL, accessToken: String, refreshToken: String, actor: String, limit: Int, cursor: Date, retry: Bool = true) async throws -> Result<(body: BlueskyFeedGetAuthorFeedResponseBody, credentials: (accessToken: String, refreshToken: String)?), BlueskyClientError> {
        try await makeRequest(lexicon: "app.bsky.feed.getAuthorFeed",
                              host: host,
                              credentials: (accessToken, refreshToken),
                              body: nil as String?,
                              parameters: ["actor" : actor,
                                           "limit" : limit,
                                           "cursor" : ISO8601DateFormatter().string(from: cursor)])
    }

    public static func getTimeline(host: URL, accessToken: String, refreshToken: String, algorithm: String, limit: Int, cursor: Date, retry: Bool = true) async throws -> Result<(body: BlueskyFeedGetTimelineResponseBody, credentials: (accessToken: String, refreshToken: String)?), BlueskyClientError> {
        try await makeRequest(lexicon: "app.bsky.feed.getTimeline",
                              host: host,
                              credentials: (accessToken, refreshToken),
                              body: nil as String?,
                              parameters: ["algorithm" : algorithm,
                                           "limit" : limit,
                                           "cursor" : ISO8601DateFormatter().string(from: cursor)])
    }

    public static func getPostThread(host: URL, accessToken: String, refreshToken: String, uri: String, depth: Int = 6, parentHeight: Int = 80, retry: Bool = true) async throws -> Result<(body: BlueskyFeedGetPostThreadResponseBody, credentials: (accessToken: String, refreshToken: String)?), BlueskyClientError> {
        try await makeRequest(lexicon: "app.bsky.feed.getPostThread",
                              host: host,
                              credentials: (accessToken, refreshToken),
                              body: nil as String?,
                              parameters: ["uri" : uri,
                                           "depth" : depth,
                                           "parentHeight" : parentHeight])
    }

    public static func getPosts(host: URL, accessToken: String, refreshToken: String, uris: [String], retry: Bool = true) async throws -> Result<(body: BlueskyFeedGetPostsResponseBody, credentials: (accessToken: String, refreshToken: String)?), BlueskyClientError> {
        try await makeRequest(lexicon: "app.bsky.feed.getPosts",
                              host: host,
                              credentials: (accessToken, refreshToken),
                              body: nil as String?,
                              parameters: ["uris" : uris])
    }

    public static func createLike(host: URL, accessToken: String, refreshToken: String, repo: String, uri: String, cid: String, retry: Bool = true) async throws -> Result<(body: ATProtoRepoCreateRecordResponseBody, credentials: (accessToken: String, refreshToken: String)?), BlueskyClientError> {
        let like = BlueskyFeedLike(subject: ATProtoRepoStrongRef(uri: uri,
                                                                 cid: cid),
                                   createdAt: Date())

        let createLikeRecordRequestBody = ATProtoRepoCreateRecordRequestBody(repo: repo,
                                                                             collection: "app.bsky.feed.like",
                                                                             record: like)

        return try await makeRequest(lexicon: "com.atproto.repo.createRecord",
                                     host: host,
                                     credentials: (accessToken, refreshToken),
                                     body: createLikeRecordRequestBody,
                                     parameters: [:])
    }

    public static func deleteLike(host: URL, accessToken: String, refreshToken: String, repo: String, rkey: String, retry: Bool = true) async throws -> Result<(body: BlueskyEmptyReponseBody, credentials: (accessToken: String, refreshToken: String)?), BlueskyClientError> {
        let deleteLikeRecordRequestBody = ATProtoRepoDeleteRecordRequestBody(repo: repo,
                                                                             collection: "app.bsky.feed.like",
                                                                             rkey: rkey)

        return try await makeRequest(lexicon: "com.atproto.repo.deleteRecord",
                                     host: host,
                                     credentials: (accessToken, refreshToken),
                                     body: deleteLikeRecordRequestBody,
                                     parameters: [:])
    }

    public static func createRepost(host: URL, accessToken: String, refreshToken: String, repo: String, uri: String, cid: String, retry: Bool = true) async throws -> Result<(body: ATProtoRepoCreateRecordResponseBody, credentials: (accessToken: String, refreshToken: String)?), BlueskyClientError> {
        let repost = BlueskyFeedRepost(subject: ATProtoRepoStrongRef(uri: uri,
                                                                 cid: cid),
                                       createdAt: Date())

        let createRepostRecordRequestBody = ATProtoRepoCreateRecordRequestBody(repo: repo,
                                                                               collection: "app.bsky.feed.repost",
                                                                               record: repost)

        return try await makeRequest(lexicon: "com.atproto.repo.createRecord",
                                     host: host,
                                     credentials: (accessToken, refreshToken),
                                     body: createRepostRecordRequestBody,
                                     parameters: [:])
    }

    public static func deleteRepost(host: URL, accessToken: String, refreshToken: String, repo: String, rkey: String, retry: Bool = true) async throws -> Result<(body: BlueskyEmptyReponseBody, credentials: (accessToken: String, refreshToken: String)?), BlueskyClientError> {
        let deleteRepostRecordRequestBody = ATProtoRepoDeleteRecordRequestBody(repo: repo,
                                                                               collection: "app.bsky.feed.deleteRecord",
                                                                               rkey: rkey)

        return try await makeRequest(lexicon: "com.atproto.repo.deleteRecord",
                                     host: host,
                                     credentials: (accessToken, refreshToken),
                                     body: deleteRepostRecordRequestBody,
                                     parameters: [:])
    }

    public static func muteThread(host: URL, accessToken: String, refreshToken: String, root: String, retry: Bool = true) async throws -> Result<(body: BlueskyEmptyReponseBody, credentials: (accessToken: String, refreshToken: String)?), BlueskyClientError> {
        let muteThreadRequestBody = BlueskyGraphMuteThreadRequestBody(root: root)

        return try await makeRequest(lexicon: "app.bsky.graph.muteThread",
                                     host: host,
                                     credentials: (accessToken, refreshToken),
                                     body: muteThreadRequestBody,
                                     parameters: [:])
    }

    public static func unmuteThread(host: URL, accessToken: String, refreshToken: String, root: String, retry: Bool = true) async throws -> Result<(body: BlueskyEmptyReponseBody, credentials: (accessToken: String, refreshToken: String)?), BlueskyClientError> {
        let unmuteThreadRequestBody = BlueskyGraphMuteThreadRequestBody(root: root)

        return try await makeRequest(lexicon: "app.bsky.graph.unmuteThread",
                                     host: host,
                                     credentials: (accessToken, refreshToken),
                                     body: unmuteThreadRequestBody,
                                     parameters: [:])
    }

    struct Feed {
        public static func getActorLikes(host: URL, accessToken: String, refreshToken: String, actor: String, limit: Int, cursor: Date, retry: Bool = true) async throws -> Result<(body: BlueskyFeedGetAuthorFeedResponseBody, credentials: (accessToken: String, refreshToken: String)?), BlueskyClientError> {
            try await makeRequest(lexicon: "app.bsky.feed.getActorLikes",
                                  host: host,
                                  credentials: (accessToken, refreshToken),
                                  body: nil as String?,
                                  parameters: ["actor" : actor,
                                               "limit" : limit,
                                               "cursor" : ISO8601DateFormatter().string(from: cursor)])
        }
    }
}
