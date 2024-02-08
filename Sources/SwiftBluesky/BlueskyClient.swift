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
    public init() {}

    public func createSession(host: URL, identifier: String, password: String) async throws -> Result<ATProtoServerCreateSessionResponseBody, BlueskyClientError> {
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

                let createSessionResponse: Result<ATProtoServerCreateSessionResponseBody, ATProtoHTTPClientError> = await ATProtoHTTPClient().make(request: createSessionRequest)

                switch createSessionResponse {
                case .success(let createSessionResponseBody):
                    return .success(createSessionResponseBody)
                
                case .failure(let error):
                    return .failure(BlueskyClientError(atProtoHTTPClientError: error))
                }

            default:
                return .failure(.invalidRequest)
            }
        }
        
        return .failure(.unknown)
    }

    public func refreshSession(host: URL, refreshToken: String) async throws -> Result<ATProtoServerRefreshSessionResponseBody, BlueskyClientError> {
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

                let refreshSessionResponse: Result<ATProtoServerRefreshSessionResponseBody, ATProtoHTTPClientError> = await ATProtoHTTPClient().make(request: refreshSessionRequest)

                switch refreshSessionResponse {
                case .success(let refreshSessionResponseBody):
                    return .success(refreshSessionResponseBody)

                case .failure(let error):
                    return .failure(BlueskyClientError(atProtoHTTPClientError: error))
                }

            default:
                return .failure(.invalidRequest)
            }
        }

        return .failure(.unknown)
    }

    public func getProfiles(host: URL, accessToken: String, refreshToken: String, actors: [String], retry: Bool = true) async throws -> Result<(body: BlueskyActorGetProfilesResponseBody, credentials: (accessToken: String, refreshToken: String)?), BlueskyClientError> {
        let getProfilesLexicon = try JSONDecoder().decode(Lexicon.self,
                                                          from: try Data(contentsOf: Bundle.module.url(forResource: "app.bsky.actor.getProfiles",
                                                                                                       withExtension: "json")!))

        if let mainDef = getProfilesLexicon.defs["main"] {
            switch mainDef {
            case .query(let query):
                let getProfilesRequest = try ATProtoHTTPRequest(host: host, 
                                                                nsid: getProfilesLexicon.id,
                                                                parameters: ["actors" : actors],
                                                                body: nil,
                                                                token: accessToken, 
                                                                requestable: query)

                let getProfilesResponse: Result<BlueskyActorGetProfilesResponseBody, ATProtoHTTPClientError> = await ATProtoHTTPClient().make(request: getProfilesRequest)

                switch getProfilesResponse {
                case .success(let getProfilesResponseBody):
                    return .success((body: getProfilesResponseBody,
                                     credentials: retry == false ? (accessToken: accessToken,
                                                                    refreshToken: refreshToken) : nil))

                case .failure(let error):
                    switch(error) {
                    case .badRequest:
                        if retry == true {
                            switch(try await self.refreshSession(host: host, refreshToken: refreshToken)) {
                            case .success(let refreshSessionResponseBody):
                                return try await self.getProfiles(host: host,
                                                                  accessToken: refreshSessionResponseBody.accessJwt,
                                                                  refreshToken: refreshSessionResponseBody.refreshJwt,
                                                                  actors: actors,
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

            default:
                return .failure(.invalidRequest)
            }
        }

        return .failure(.unknown)
    }

    public func getAuthorFeed(host: URL, accessToken: String, refreshToken: String, actor: String, limit: Int, cursor: Date, retry: Bool = true) async throws -> Result<(body: BlueskyFeedGetAuthorFeedResponseBody, credentials: (accessToken: String, refreshToken: String)?), BlueskyClientError> {
        let getAuthorFeedLexicon = try JSONDecoder().decode(Lexicon.self, from:
                                                                try Data(contentsOf: Bundle.module.url(forResource: "app.bsky.feed.getAuthorFeed",
                                                                                                       withExtension: "json")!))

        if let mainDef = getAuthorFeedLexicon.defs["main"] {
            switch mainDef {
            case .query(let query):
                let getAuthorFeedRequest = try ATProtoHTTPRequest(host: host, 
                                                                  nsid: getAuthorFeedLexicon.id,
                                                                  parameters: ["actor" : actor, 
                                                                               "limit" : limit,
                                                                               "cursor" : ISO8601DateFormatter().string(from: cursor)],
                                                                  body: nil,
                                                                  token: accessToken,
                                                                  requestable: query)

                let getAuthorFeedResponse: Result<BlueskyFeedGetAuthorFeedResponseBody, ATProtoHTTPClientError> = await ATProtoHTTPClient().make(request: getAuthorFeedRequest)

                switch getAuthorFeedResponse {
                case .success(let getAuthorFeedResponseBody):
                    return .success((body: getAuthorFeedResponseBody,
                                     credentials: retry == false ? (accessToken: accessToken,
                                                                    refreshToken: refreshToken) : nil))

                case .failure(let error):
                    switch(error) {
                    case .badRequest:
                        if retry == true {
                            switch(try await self.refreshSession(host: host, refreshToken: refreshToken)) {
                            case .success(let refreshSessionResponseBody):
                                return try await self.getAuthorFeed(host: host,
                                                                    accessToken: refreshSessionResponseBody.accessJwt,
                                                                    refreshToken: refreshSessionResponseBody.refreshJwt,
                                                                    actor: actor,
                                                                    limit: limit,
                                                                    cursor: cursor,
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

            default:
                return .failure(.invalidRequest)
            }
        }

        return .failure(.unknown)
    }

    public func getTimeline(host: URL, accessToken: String, refreshToken: String, algorithm: String, limit: Int, cursor: Date, retry: Bool = true) async throws -> Result<(body: BlueskyFeedGetTimelineResponseBody, credentials: (accessToken: String, refreshToken: String)?), BlueskyClientError> {
        let getTimelineLexicon = try JSONDecoder().decode(Lexicon.self,
                                                          from: try Data(contentsOf: Bundle.module.url(forResource: "app.bsky.feed.getTimeline",
                                                                                                       withExtension: "json")!))

        if let mainDef = getTimelineLexicon.defs["main"] {
            switch mainDef {
            case .query(let query):
                let getTimelineRequest = try ATProtoHTTPRequest(host: host,
                                                                  nsid: getTimelineLexicon.id,
                                                                  parameters: ["algorithm" : algorithm,
                                                                               "limit" : limit,
                                                                               "cursor" : ISO8601DateFormatter().string(from: cursor)],
                                                                  body: nil,
                                                                  token: accessToken,
                                                                  requestable: query)

                let getTimelineResponse: Result<BlueskyFeedGetTimelineResponseBody, ATProtoHTTPClientError> = await ATProtoHTTPClient().make(request: getTimelineRequest)

                switch getTimelineResponse {
                case .success(let getTimelineResponseBody):

                    return .success((body: getTimelineResponseBody,
                                     credentials: retry == false ? (accessToken: accessToken,
                                                                      refreshToken: refreshToken) : nil))

                case .failure(let error):
                    switch(error) {
                    case .badRequest:
                        if retry == true {
                            switch(try await self.refreshSession(host: host, refreshToken: refreshToken)) {
                            case .success(let refreshSessionResponseBody):
                                return try await self.getTimeline(host: host,
                                                                  accessToken: refreshSessionResponseBody.accessJwt,
                                                                  refreshToken: refreshSessionResponseBody.refreshJwt,
                                                                  algorithm: algorithm,
                                                                  limit: limit,
                                                                  cursor: cursor,
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

            default:
                return .failure(.invalidRequest)
            }
        }

        return .failure(.unknown)
    }

    public func getPostThread(host: URL, accessToken: String, refreshToken: String, uri: String, depth: Int = 6, parentHeight: Int = 80, retry: Bool = true) async throws -> Result<(body: BlueskyFeedGetPostThreadResponseBody, credentials: (accessToken: String, refreshToken: String)?), BlueskyClientError> {
        let getPostThreadLexicon = try JSONDecoder().decode(Lexicon.self,
                                                            from: try Data(contentsOf: Bundle.module.url(forResource: "app.bsky.feed.getPostThread",
                                                                                                         withExtension: "json")!))

        if let mainDef = getPostThreadLexicon.defs["main"] {
            switch mainDef {
            case .query(let query):
                let getPostThreadRequest = try ATProtoHTTPRequest(host: host,
                                                                  nsid: getPostThreadLexicon.id,
                                                                  parameters: ["uri" : uri,
                                                                               "depth" : depth,
                                                                               "parentHeight" : parentHeight],
                                                                  body: nil,
                                                                  token: accessToken,
                                                                  requestable: query)

                let getPostThreadResponse: Result<BlueskyFeedGetPostThreadResponseBody, ATProtoHTTPClientError> = await ATProtoHTTPClient().make(request: getPostThreadRequest)

                switch getPostThreadResponse {
                case .success(let getPostThreadResponseBody):
                    return .success((body: getPostThreadResponseBody,
                                     credentials: retry == false ? (accessToken: accessToken,
                                                                      refreshToken: refreshToken) : nil))

                case .failure(let error):
                    switch(error) {
                    case .badRequest:
                        if retry == true {
                            switch(try await self.refreshSession(host: host, refreshToken: refreshToken)) {
                            case .success(let refreshSessionResponseBody):
                                return try await self.getPostThread(host: host,
                                                                    accessToken: refreshSessionResponseBody.accessJwt,
                                                                    refreshToken: refreshSessionResponseBody.refreshJwt,
                                                                    uri: uri,
                                                                    depth: depth,
                                                                    parentHeight: parentHeight,
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

            default:
                return .failure(.invalidRequest)
            }

        } else {
            return .failure(.unknown)
        }
    }

    public func getPosts(host: URL, accessToken: String, refreshToken: String, uris: [String], retry: Bool = true) async throws -> Result<(body: BlueskyFeedGetPostsResponseBody, credentials: (accessToken: String, refreshToken: String)?), BlueskyClientError> {
        let getPostsLexicon = try JSONDecoder().decode(Lexicon.self, 
                                                       from: try Data(contentsOf: Bundle.module.url(forResource: "app.bsky.feed.getPosts",
                                                                                                    withExtension: "json")!))

        if let mainDef = getPostsLexicon.defs["main"] {
            switch mainDef {
            case .query(let query):
                let getPostsRequest = try ATProtoHTTPRequest(host: host,
                                                                  nsid: getPostsLexicon.id,
                                                                  parameters: ["uris" : uris],
                                                                  body: nil,
                                                                  token: accessToken,
                                                                  requestable: query)

                let getPostsResponse: Result<BlueskyFeedGetPostsResponseBody, ATProtoHTTPClientError> = await ATProtoHTTPClient().make(request: getPostsRequest)
  
                switch getPostsResponse {
                case .success(let getPostsResponseBody):
                    return .success((body: getPostsResponseBody,
                                     credentials: retry == false ? (accessToken: accessToken,
                                                                    refreshToken: refreshToken) : nil))

                case .failure(let error):
                    switch(error) {
                    case .badRequest:
                        if retry == true {
                            switch(try await self.refreshSession(host: host, refreshToken: refreshToken)) {
                            case .success(let refreshSessionResponseBody):
                                return try await self.getPosts(host: host,
                                                               accessToken: refreshSessionResponseBody.accessJwt,
                                                               refreshToken: refreshSessionResponseBody.refreshJwt,
                                                               uris: uris,
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

            default:
                return .failure(.invalidRequest)
            }

        } else {
            return .failure(.unknown)
        }
    }

    public func createLike(host: URL, accessToken: String, refreshToken: String, repo: String, uri: String, cid: String, retry: Bool = true) async throws -> Result<(body: ATProtoRepoCreateRecordResponseBody, credentials: (accessToken: String, refreshToken: String)?), BlueskyClientError> {



        let createRecordLexicon = try JSONDecoder().decode(Lexicon.self,
                                                            from: try Data(contentsOf: Bundle.module.url(forResource: "com.atproto.repo.createRecord",
                                                                                                         withExtension: "json")!))

        if let mainDef = createRecordLexicon.defs["main"] {
            switch mainDef {
            case .procedure(let procedure):
                let like = BlueskyFeedLike(subject: ATProtoRepoStrongRef(uri: uri, cid: cid),
                                           createdAt: Date())

                let createRecordRequestBody = ATProtoRepoCreateRecordRequestBody(repo: repo,
                                                                             collection: "app.bsky.feed.like",
                                                                             record: like)

                let createRecordRequest = try ATProtoHTTPRequest(host: host,
                                                                  nsid: createRecordLexicon.id,
                                                                  parameters: [:],
                                                                  body: createRecordRequestBody,
                                                                  token: accessToken,
                                                                  requestable: procedure)

                let createRecordResponse: Result<ATProtoRepoCreateRecordResponseBody, ATProtoHTTPClientError> = await ATProtoHTTPClient().make(request: createRecordRequest)

                switch createRecordResponse {
                case .success(let createRecordResponse):
                    return .success((body: createRecordResponse,
                                     credentials: retry == false ? (accessToken: accessToken,
                                                                    refreshToken: refreshToken) : nil))

                case .failure(let error):
                    switch(error) {
                    case .badRequest:
                        if retry == true {
                            switch(try await self.refreshSession(host: host, refreshToken: refreshToken)) {
                            case .success(let refreshSessionResponseBody):
                                return try await self.createLike(host: host, 
                                                                 accessToken: accessToken,
                                                                 refreshToken: refreshToken,
                                                                 repo: repo,
                                                                 uri: uri,
                                                                 cid: cid,
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

            default:
                return .failure(.invalidRequest)
            }
        }

        return .failure(.unknown)
    }
}
