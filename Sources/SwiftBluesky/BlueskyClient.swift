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

    public func createSession(host: URL, identifier: String, password: String) async throws -> Result<CreateSessionResponseBody, BlueskyClientError> {
        let createSessionJSONURL = Bundle.module.url(forResource: "com.atproto.server.createSession", withExtension: "json")!
        
        let createSessionJSONData = try Data(contentsOf: createSessionJSONURL)
        
        let createSessionLexicon = try JSONDecoder().decode(Lexicon.self, from: createSessionJSONData)

        if let mainDef = createSessionLexicon.defs["main"] {
            switch mainDef {
            case .procedure(let procedure):
                let createSessionRequestBody = CreateSessionRequestBody(identifier: identifier, password: password)
                
                let createSessionRequest = try ATProtoHTTPRequest(host: host, nsid: createSessionLexicon.id, parameters: [:], body: createSessionRequestBody, token: nil, requestable: procedure)

                let createSessionResponse: Result<CreateSessionResponseBody, ATProtoHTTPClientError> = try await ATProtoHTTPClient().make(request: createSessionRequest)

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
        
        return .failure(BlueskyClientError.unknown)
    }

    public func getProfiles(host: URL, token: String, actors: [String]) async throws -> Result<GetProfilesResponseBody, BlueskyClientError> {
        let getProfilesJSONURL = Bundle.module.url(forResource: "app.bsky.actor.getProfiles", withExtension: "json")!
        
        let getProfilesJSONData = try Data(contentsOf: getProfilesJSONURL)
        
        let getProfilesLexicon = try JSONDecoder().decode(Lexicon.self, from: getProfilesJSONData)
        
        if let mainDef = getProfilesLexicon.defs["main"] {
            switch mainDef {
            case .query(let query):
                let getProfilesRequest = try ATProtoHTTPRequest(host: host, nsid: getProfilesLexicon.id, parameters: ["actors" : actors], body: nil, token: token, requestable: query)

                let getProfilesResponse: Result<GetProfilesResponseBody, ATProtoHTTPClientError> = try await ATProtoHTTPClient().make(request: getProfilesRequest)

                switch getProfilesResponse {
                case .success(let getProfilesResponseBody):
                    return .success(getProfilesResponseBody)

                case .failure(let error):
                    return .failure(BlueskyClientError(atProtoHTTPClientError: error))
                }
            default:
                return .failure(.invalidRequest)
            }
        }

        return .failure(BlueskyClientError.unknown)
    }

    public func getAuthorFeed(host: URL, token: String, actor: String, limit: Int, cursor: String) async throws -> Result<GetAuthorFeedResponseBody, BlueskyClientError> {
        let getAuthorFeedJSONURL = Bundle.module.url(forResource: "app.bsky.feed.getAuthorFeed", withExtension: "json")!
        
        let getAuthorFeedJSONData = try Data(contentsOf: getAuthorFeedJSONURL)
        
        let getAuthorFeedLexicon = try JSONDecoder().decode(Lexicon.self, from: getAuthorFeedJSONData)
        
        if let mainDef = getAuthorFeedLexicon.defs["main"] {
            switch mainDef {
            case .query(let query):
                let getAuthorFeedRequest = try ATProtoHTTPRequest(host: host, nsid: getAuthorFeedLexicon.id, parameters: ["actor" : actor, "limit" : limit, "cursor" : cursor], body: nil, token: token, requestable: query)

                let getAuthorFeedResponse: Result<GetAuthorFeedResponseBody, ATProtoHTTPClientError> = try await ATProtoHTTPClient().make(request: getAuthorFeedRequest)

                switch getAuthorFeedResponse {
                case .success(let getAuthorFeedResponseBody):
                    return .success(getAuthorFeedResponseBody)

                case .failure(let error):
                    return .failure(BlueskyClientError(atProtoHTTPClientError: error))
                }
            default:
                return .failure(.invalidRequest)
            }
        }

        return .failure(.unknown)
    }

    public func refreshSession(host: URL, token: String) async throws -> Result<RefreshSessionResponseBody, BlueskyClientError> {
        let refreshSessionJSONURL = Bundle.module.url(forResource: "com.atproto.server.refreshSession", withExtension: "json")!
        
        let refreshSessionJSONData = try Data(contentsOf: refreshSessionJSONURL)
        
        let refreshSessionLexicon = try JSONDecoder().decode(Lexicon.self, from: refreshSessionJSONData)

        if let mainDef = refreshSessionLexicon.defs["main"] {
            switch mainDef {
            case .procedure(let procedure):
                let refreshSessionRequest = try ATProtoHTTPRequest(host: host, nsid: refreshSessionLexicon.id, parameters: [:], body: nil, token: token, requestable: procedure)

                let refreshSessionResponse: Result<RefreshSessionResponseBody, ATProtoHTTPClientError> = try await ATProtoHTTPClient().make(request: refreshSessionRequest)

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
