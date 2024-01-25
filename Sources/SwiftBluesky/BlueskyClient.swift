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

    public func createSession(host: URL, identifier: String, password: String) async throws -> Result<ATProtoCreateSessionResponseBody, BlueskyClientError> {
        let createSessionJSONURL = Bundle.module.url(forResource: "com.atproto.server.createSession", withExtension: "json")!
        
        let createSessionJSONData = try Data(contentsOf: createSessionJSONURL)
        
        let createSessionLexicon = try JSONDecoder().decode(Lexicon.self, from: createSessionJSONData)

        if let mainDef = createSessionLexicon.defs["main"] {
            switch mainDef {
            case .procedure(let procedure):
                let createSessionRequestBody = ATProtoCreateSessionRequestBody(identifier: identifier, password: password)

                let createSessionRequest = try ATProtoHTTPRequest(host: host, nsid: createSessionLexicon.id, parameters: [:], body: createSessionRequestBody, token: nil, requestable: procedure)
                
                let createSessionResponse: Result<ATProtoCreateSessionResponseBody, ATProtoHTTPClientError> = await ATProtoHTTPClient().make(request: createSessionRequest)

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

    public func getProfiles(host: URL, accessToken: String, refreshToken: String?, actors: [String]) async throws -> Result<BlueskyGetProfilesResponseBody, BlueskyClientError> {
        let getProfilesJSONURL = Bundle.module.url(forResource: "app.bsky.actor.getProfiles", withExtension: "json")!
        
        let getProfilesJSONData = try Data(contentsOf: getProfilesJSONURL)
        
        let getProfilesLexicon = try JSONDecoder().decode(Lexicon.self, from: getProfilesJSONData)
        
        if let mainDef = getProfilesLexicon.defs["main"] {
            switch mainDef {
            case .query(let query):
                let getProfilesRequest = try ATProtoHTTPRequest(host: host, 
                                                                nsid: getProfilesLexicon.id,
                                                                parameters: ["actors" : actors],
                                                                body: nil,
                                                                token: accessToken, 
                                                                requestable: query)

                let getProfilesResponse: Result<BlueskyGetProfilesResponseBody, ATProtoHTTPClientError> = await ATProtoHTTPClient().make(request: getProfilesRequest)

                switch getProfilesResponse {
                case .success(let getProfilesResponseBody):
                    return .success(getProfilesResponseBody)

                case .failure(let error):
                    switch(error) {
                    case .badRequest:
                        if let refreshToken = refreshToken {
                            switch(try await self.refreshSession(host: host, refreshToken: refreshToken)) {
                            case .success(let refreshSessionResponseBody):
                                return try await self.getProfiles(host: host, accessToken: refreshSessionResponseBody.accessJwt, refreshToken: nil, actors: actors)

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

    public func getAuthorFeed(host: URL, accessToken: String, refreshToken: String?, actor: String, limit: Int, cursor: String) async throws -> Result<BlueskyGetAuthorFeedResponseBody, BlueskyClientError> {
        let getAuthorFeedJSONURL = Bundle.module.url(forResource: "app.bsky.feed.getAuthorFeed", withExtension: "json")!
        
        let getAuthorFeedJSONData = try Data(contentsOf: getAuthorFeedJSONURL)
        
        let getAuthorFeedLexicon = try JSONDecoder().decode(Lexicon.self, from: getAuthorFeedJSONData)
        
        if let mainDef = getAuthorFeedLexicon.defs["main"] {
            switch mainDef {
            case .query(let query):
                let getAuthorFeedRequest = try ATProtoHTTPRequest(host: host, 
                                                                  nsid: getAuthorFeedLexicon.id,
                                                                  parameters: ["actor" : actor, 
                                                                               "limit" : limit,
                                                                               "cursor" : cursor],
                                                                  body: nil,
                                                                  token: accessToken,
                                                                  requestable: query)

                let getAuthorFeedResponse: Result<BlueskyGetAuthorFeedResponseBody, ATProtoHTTPClientError> = await ATProtoHTTPClient().make(request: getAuthorFeedRequest)

                switch getAuthorFeedResponse {
                case .success(let getAuthorFeedResponseBody):
                    return .success(getAuthorFeedResponseBody)

                case .failure(let error):
                    switch(error) {
                    case .badRequest:
                        if let refreshToken = refreshToken {
                            switch(try await self.refreshSession(host: host, refreshToken: refreshToken)) {
                            case .success(let refreshSessionResponseBody):
                                return try await self.getAuthorFeed(host: host, accessToken: refreshSessionResponseBody.accessJwt, refreshToken: nil, actor: actor, limit: limit, cursor: cursor)

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

    public func refreshSession(host: URL, refreshToken: String) async throws -> Result<ATProtoRefreshSessionResponseBody, BlueskyClientError> {
        let refreshSessionJSONURL = Bundle.module.url(forResource: "com.atproto.server.refreshSession", withExtension: "json")!
        
        let refreshSessionJSONData = try Data(contentsOf: refreshSessionJSONURL)
        
        let refreshSessionLexicon = try JSONDecoder().decode(Lexicon.self, from: refreshSessionJSONData)

        if let mainDef = refreshSessionLexicon.defs["main"] {
            switch mainDef {
            case .procedure(let procedure):
                let refreshSessionRequest = try ATProtoHTTPRequest(host: host, 
                                                                   nsid: refreshSessionLexicon.id,
                                                                   parameters: [:],
                                                                   body: nil,
                                                                   token: refreshToken,
                                                                   requestable: procedure)

                let refreshSessionResponse: Result<ATProtoRefreshSessionResponseBody, ATProtoHTTPClientError> = await ATProtoHTTPClient().make(request: refreshSessionRequest)

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
}
