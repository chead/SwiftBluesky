//
//  RefreshSession.swift
//  SwiftBluesky
//
//  Created by Christopher Head on 11/10/24.
//

import Foundation
import SwiftATProto
import SwiftLexicon

public extension ATProto.Server {
    struct RefreshSessionResponseBody: Decodable {
        public let did: String
        public let handle: String
        public let accessJwt: String
        public let refreshJwt: String
    }

    enum RefreshSessionError: String, Decodable, Error {
        case accountTakedown = "AccountTakedown"
    }

    @available(iOS 16.0, *)
    static func refreshSession(host: URL, refreshToken: String) async -> Result<RefreshSessionResponseBody, BlueskyClientError<RefreshSessionError>> {
        guard let lexiconURL = Bundle.module.url(forResource: "com.atproto.server.refreshSession", withExtension: "json"),
              let lexiconData = try? Data(contentsOf: lexiconURL),
              let refreshSessionLexicon = try? JSONDecoder().decode(Lexicon.self, from: lexiconData) else {
            return .failure(.invalidLexicon)
        }

        switch refreshSessionLexicon.defs["main"] {
        case .procedure(let procedure):
            guard let refreshSessionRequest = try? ATProtoHTTPRequest(host: host,
                                                                      nsid: refreshSessionLexicon.id,
                                                                      parameters: [:],
                                                                      body: nil,
                                                                      token: refreshToken,
                                                                      requestable: procedure)
            else {
                return .failure(.invalidRequest)
            }

            let refreshSessionResponse: Result<RefreshSessionResponseBody, ATProtoHTTPClientError<RefreshSessionError>> = await ATProtoHTTPClient.make(request: refreshSessionRequest)

            switch refreshSessionResponse {
            case .success(let refreshSessionResult):
                return .success(refreshSessionResult)

            case .failure(let refreshSessionError):
                return .failure(.atProtoClient(error: refreshSessionError))
            }

        default:
            return .failure(.invalidLexicon)
        }
    }
}
