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
    case invalidResponse
    case unknown
}

@available(iOS 16.0, *)
public class BlueskyClient {
    public let host: URL
    
    public init(host: URL) {
        self.host = host
    }

    public func createSession(identifier: String, password: String) async throws -> Result<CreateSessionResponseBody, Error> {
        let createSessionJSONURL = Bundle.module.url(forResource: "com.atproto.server.createSession", withExtension: "json")!
        
        let createSessionJSONData = try Data(contentsOf: createSessionJSONURL)
        
        let createSessionLexicon = try JSONDecoder().decode(Lexicon.self, from: createSessionJSONData)

        if let mainDef = createSessionLexicon.defs["main"] {
            switch mainDef {
            case .procedure(let procedure):
                let createSessionRequestBody = CreateSessionRequestBody(identifier: identifier, password: password)
                
                let createSessionRequest = try ATProtoHTTPRequest(host: host, nsid: createSessionLexicon.id, parameters: [:], body: createSessionRequestBody, token: nil, requestable: procedure)

                let createSessionResponse: Result<CreateSessionResponseBody, Error> = try await ATProtoHTTPClient().make(request: createSessionRequest)

                switch createSessionResponse {
                case .success(let createSessionResponseBody):
                    return .success(createSessionResponseBody)
                
                case .failure(_):
                    return .failure(BlueskyClientError.invalidResponse)
                }
            default:
                break
            }
        }
        
        return .failure(BlueskyClientError.unknown)
    }

    public func getProfiles(token: String, actors: [String]) async throws -> Result<GetProfilesResponseBody, Error> {
        let getProfilesJSONURL = Bundle.module.url(forResource: "app.bsky.actor.getProfiles", withExtension: "json")!
        
        let getProfilesJSONData = try Data(contentsOf: getProfilesJSONURL)
        
        let getProfilesLexicon = try JSONDecoder().decode(Lexicon.self, from: getProfilesJSONData)
        
        if let mainDef = getProfilesLexicon.defs["main"] {
            switch mainDef {
            case .query(let query):
                let getProfilesRequest = try ATProtoHTTPRequest(host: host, nsid: getProfilesLexicon.id, parameters: ["actors" : actors], body: nil, token: token, requestable: query)

                let getProfilesResponse: Result<GetProfilesResponseBody, Error> = try await ATProtoHTTPClient().make(request: getProfilesRequest)

                switch getProfilesResponse {
                case .success(let getProfilesResponseBody):
                    return .success(getProfilesResponseBody)

                case .failure(_):
                    return .failure(BlueskyClientError.invalidResponse)
                }
            default:
                break
            }
        }

        return .failure(BlueskyClientError.unknown)
    }

    public func refreshSession(token: String) async throws -> Result<RefreshSessionResponseBody, Error> {
        let refreshSessionJSONURL = Bundle.module.url(forResource: "com.atproto.server.refreshSession", withExtension: "json")!
        
        let refreshSessionJSONData = try Data(contentsOf: refreshSessionJSONURL)
        
        let refreshSessionLexicon = try JSONDecoder().decode(Lexicon.self, from: refreshSessionJSONData)

        if let mainDef = refreshSessionLexicon.defs["main"] {
            switch mainDef {
            case .procedure(let procedure):
                let refreshSessionRequest = try ATProtoHTTPRequest(host: host, nsid: refreshSessionLexicon.id, parameters: [:], body: nil, token: token, requestable: procedure)

                let refreshSessionResponse: Result<RefreshSessionResponseBody, Error> = try await ATProtoHTTPClient().make(request: refreshSessionRequest)

                switch refreshSessionResponse {
                case .success(let refreshSessionResponseBody):
                    return .success(refreshSessionResponseBody)
                
                case .failure(_):
                    return .failure(BlueskyClientError.invalidResponse)
                }
            default:
                break
            }
        }
        
        return .failure(BlueskyClientError.unknown)
    }
}
