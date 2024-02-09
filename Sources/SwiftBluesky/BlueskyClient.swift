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

                let getProfilesResult: Result<BlueskyActorGetProfilesResponseBody?, ATProtoHTTPClientError> = await ATProtoHTTPClient().make(request: getProfilesRequest)

                switch getProfilesResult {
                case .success(let getProfilesResponse):
                    guard let getProfilesResponse = getProfilesResponse else { return .failure(.invalidResponse) }

                    return .success((body: getProfilesResponse,
                                     credentials: retry == false ? (accessToken: accessToken,
                                                                    refreshToken: refreshToken) : nil))

                case .failure(let error):
                    switch(error) {
                    case .badRequest:
                        if retry == true {
                            switch(try await self.refreshSession(host: host, refreshToken: refreshToken)) {
                            case .success(let refreshSessionResponse):
                                return try await self.getProfiles(host: host,
                                                                  accessToken: refreshSessionResponse.accessJwt,
                                                                  refreshToken: refreshSessionResponse.refreshJwt,
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

                let getAuthorFeedResult: Result<BlueskyFeedGetAuthorFeedResponseBody?, ATProtoHTTPClientError> = await ATProtoHTTPClient().make(request: getAuthorFeedRequest)

                switch getAuthorFeedResult {
                case .success(let getAuthorFeedResponse):
                    guard let getAuthorFeedResponse = getAuthorFeedResponse else { return .failure(.invalidResponse) }

                    return .success((body: getAuthorFeedResponse,
                                     credentials: retry == false ? (accessToken: accessToken,
                                                                    refreshToken: refreshToken) : nil))

                case .failure(let error):
                    switch(error) {
                    case .badRequest:
                        if retry == true {
                            switch(try await self.refreshSession(host: host, refreshToken: refreshToken)) {
                            case .success(let refreshSessionResponse):
                                return try await self.getAuthorFeed(host: host,
                                                                    accessToken: refreshSessionResponse.accessJwt,
                                                                    refreshToken: refreshSessionResponse.refreshJwt,
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

                let getTimelineResult: Result<BlueskyFeedGetTimelineResponseBody?, ATProtoHTTPClientError> = await ATProtoHTTPClient().make(request: getTimelineRequest)

                switch getTimelineResult {
                case .success(let getTimelineResponse):
                    guard let getTimelineResponse = getTimelineResponse else { return .failure(.invalidResponse) }

                    return .success((body: getTimelineResponse,
                                     credentials: retry == false ? (accessToken: accessToken,
                                                                      refreshToken: refreshToken) : nil))

                case .failure(let error):
                    switch(error) {
                    case .badRequest:
                        if retry == true {
                            switch(try await self.refreshSession(host: host, refreshToken: refreshToken)) {
                            case .success(let refreshSessionResponse):
                                return try await self.getTimeline(host: host,
                                                                  accessToken: refreshSessionResponse.accessJwt,
                                                                  refreshToken: refreshSessionResponse.refreshJwt,
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

                let getPostThreadResult: Result<BlueskyFeedGetPostThreadResponseBody?, ATProtoHTTPClientError> = await ATProtoHTTPClient().make(request: getPostThreadRequest)

                switch getPostThreadResult {
                case .success(let getPostThreadResponse):
                    guard let getPostThreadResponse = getPostThreadResponse else { return .failure(.invalidResponse) }

                    return .success((body: getPostThreadResponse,
                                     credentials: retry == false ? (accessToken: accessToken,
                                                                      refreshToken: refreshToken) : nil))

                case .failure(let error):
                    switch(error) {
                    case .badRequest:
                        if retry == true {
                            switch(try await self.refreshSession(host: host, refreshToken: refreshToken)) {
                            case .success(let refreshSessionResponse):
                                return try await self.getPostThread(host: host,
                                                                    accessToken: refreshSessionResponse.accessJwt,
                                                                    refreshToken: refreshSessionResponse.refreshJwt,
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

                let getPostsResult: Result<BlueskyFeedGetPostsResponseBody?, ATProtoHTTPClientError> = await ATProtoHTTPClient().make(request: getPostsRequest)

                switch getPostsResult {
                case .success(let getPostsResponse):
                    guard let getPostsResponse = getPostsResponse else { return .failure(.invalidResponse) }

                    return .success((body: getPostsResponse,
                                     credentials: retry == false ? (accessToken: accessToken,
                                                                    refreshToken: refreshToken) : nil))

                case .failure(let error):
                    switch(error) {
                    case .badRequest:
                        if retry == true {
                            switch(try await self.refreshSession(host: host, refreshToken: refreshToken)) {
                            case .success(let refreshSessionResponse):
                                return try await self.getPosts(host: host,
                                                               accessToken: refreshSessionResponse.accessJwt,
                                                               refreshToken: refreshSessionResponse.refreshJwt,
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
                let like = BlueskyFeedLike(subject: ATProtoRepoStrongRef(uri: uri, 
                                                                         cid: cid),
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

                let createRecordResult: Result<ATProtoRepoCreateRecordResponseBody?, ATProtoHTTPClientError> = await ATProtoHTTPClient().make(request: createRecordRequest)

                switch createRecordResult {
                case .success(let createRecordResponse):
                    guard let createRecordResponse = createRecordResponse else { return .failure(.invalidResponse) }

                    return .success((body: createRecordResponse,
                                     credentials: retry == false ? (accessToken: accessToken,
                                                                    refreshToken: refreshToken) : nil))

                case .failure(let error):
                    switch(error) {
                    case .badRequest:
                        if retry == true {
                            switch(try await self.refreshSession(host: host, refreshToken: refreshToken)) {
                            case .success(let refreshSessionResponse):
                                return try await self.createLike(host: host, 
                                                                 accessToken: refreshSessionResponse.accessJwt,
                                                                 refreshToken: refreshSessionResponse.refreshJwt,
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

    public func deleteLike(host: URL, accessToken: String, refreshToken: String, repo: String, rkey: String, retry: Bool = true) async throws -> BlueskyClientError? {
        let deleteRecordLexicon = try JSONDecoder().decode(Lexicon.self,
                                                           from: try Data(contentsOf: Bundle.module.url(forResource: "com.atproto.repo.deleteRecord",
                                                                                                         withExtension: "json")!))

        if let mainDef = deleteRecordLexicon.defs["main"] {
            switch mainDef {
            case .procedure(let procedure):
                let deleteRecordRequestBody = ATProtoRepoDeleteRecordRequestBody(repo: repo,
                                                                                 collection: "app.bsky.feed.like",
                                                                                 rkey: rkey)

                let deleteRecordRequest = try ATProtoHTTPRequest(host: host,
                                                                 nsid: deleteRecordLexicon.id,
                                                                 parameters: [:],
                                                                 body: deleteRecordRequestBody,
                                                                 token: accessToken,
                                                                 requestable: procedure)

                let deleteRecordResult: Result<ATProtoEmptyResponseBody?, ATProtoHTTPClientError> = await ATProtoHTTPClient().make(request: deleteRecordRequest)

                switch deleteRecordResult {
                case .success(_):
                    return nil

                case .failure(let error):
                    switch(error) {
                    case .badRequest:
                        if retry == true {
                            switch(try await self.refreshSession(host: host, refreshToken: refreshToken)) {
                            case .success(let refreshSessionResponse):
                                return try await self.deleteLike(host: host,
                                                                 accessToken: refreshSessionResponse.accessJwt,
                                                                 refreshToken: refreshSessionResponse.refreshJwt,
                                                                 repo: repo,
                                                                 rkey: rkey,
                                                                 retry: false)

                            case .failure(let error):
                                return error
                            }
                        } else {
                            return .unauthorized
                        }

                    default:
                        return BlueskyClientError(atProtoHTTPClientError: error)
                    }
                }

            default:
                return .invalidRequest
            }
        }

        return .unknown
    }

    public func createRepost(host: URL, accessToken: String, refreshToken: String, repo: String, uri: String, cid: String, retry: Bool = true) async throws -> Result<(body: ATProtoRepoCreateRecordResponseBody, credentials: (accessToken: String, refreshToken: String)?), BlueskyClientError> {



        let createRecordLexicon = try JSONDecoder().decode(Lexicon.self,
                                                           from: try Data(contentsOf: Bundle.module.url(forResource: "com.atproto.repo.createRecord",
                                                                                                        withExtension: "json")!))

        if let mainDef = createRecordLexicon.defs["main"] {
            switch mainDef {
            case .procedure(let procedure):
                let repost = BlueskyFeedRepost(subject: ATProtoRepoStrongRef(uri: uri,
                                                                         cid: cid),
                                           createdAt: Date())

                let createRecordRequestBody = ATProtoRepoCreateRecordRequestBody(repo: repo,
                                                                                 collection: "app.bsky.feed.repost",
                                                                                 record: repost)

                let createRecordRequest = try ATProtoHTTPRequest(host: host,
                                                                  nsid: createRecordLexicon.id,
                                                                  parameters: [:],
                                                                  body: createRecordRequestBody,
                                                                  token: accessToken,
                                                                  requestable: procedure)

                let createRecordResult: Result<ATProtoRepoCreateRecordResponseBody?, ATProtoHTTPClientError> = await ATProtoHTTPClient().make(request: createRecordRequest)

                switch createRecordResult {
                case .success(let createRecordResponse):
                    guard let createRecordResponse = createRecordResponse else { return .failure(.invalidResponse) }

                    return .success((body: createRecordResponse,
                                     credentials: retry == false ? (accessToken: accessToken,
                                                                    refreshToken: refreshToken) : nil))

                case .failure(let error):
                    switch(error) {
                    case .badRequest:
                        if retry == true {
                            switch(try await self.refreshSession(host: host, refreshToken: refreshToken)) {
                            case .success(let refreshSessionResponse):
                                return try await self.createLike(host: host,
                                                                 accessToken: refreshSessionResponse.accessJwt,
                                                                 refreshToken: refreshSessionResponse.refreshJwt,
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

    public func deleteRepost(host: URL, accessToken: String, refreshToken: String, repo: String, rkey: String, retry: Bool = true) async throws -> BlueskyClientError? {
        let deleteRecordLexicon = try JSONDecoder().decode(Lexicon.self,
                                                           from: try Data(contentsOf: Bundle.module.url(forResource: "com.atproto.repo.deleteRecord",
                                                                                                         withExtension: "json")!))

        if let mainDef = deleteRecordLexicon.defs["main"] {
            switch mainDef {
            case .procedure(let procedure):
                let deleteRecordRequestBody = ATProtoRepoDeleteRecordRequestBody(repo: repo,
                                                                                 collection: "app.bsky.feed.repost",
                                                                                 rkey: rkey)

                let deleteRecordRequest = try ATProtoHTTPRequest(host: host,
                                                                 nsid: deleteRecordLexicon.id,
                                                                 parameters: [:],
                                                                 body: deleteRecordRequestBody,
                                                                 token: accessToken,
                                                                 requestable: procedure)

                let deleteRecordResult: Result<ATProtoEmptyResponseBody?, ATProtoHTTPClientError> = await ATProtoHTTPClient().make(request: deleteRecordRequest)

                switch deleteRecordResult {
                case .success(_):
                    return nil

                case .failure(let error):
                    switch(error) {
                    case .badRequest:
                        if retry == true {
                            switch(try await self.refreshSession(host: host, refreshToken: refreshToken)) {
                            case .success(let refreshSessionResponse):
                                return try await self.deleteLike(host: host,
                                                                 accessToken: refreshSessionResponse.accessJwt,
                                                                 refreshToken: refreshSessionResponse.refreshJwt,
                                                                 repo: repo,
                                                                 rkey: rkey,
                                                                 retry: false)

                            case .failure(let error):
                                return error
                            }
                        } else {
                            return .unauthorized
                        }

                    default:
                        return BlueskyClientError(atProtoHTTPClientError: error)
                    }
                }

            default:
                return .invalidRequest
            }
        }

        return .unknown
    }
}
