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
    static func refreshSession(host: URL, refreshToken: String) async throws -> Result<RefreshSessionResponseBody, ClientError<RefreshSessionError>> {
        let refreshSessionLexicon = try JSONDecoder().decode(Lexicon.self,
                                                             from: try Data(contentsOf: Bundle.module.url(forResource: "com.atproto.server.refreshSession",
                                                                                                          withExtension: "json")!))

        switch refreshSessionLexicon.defs["main"] {
        case .procedure(let procedure):
            let refreshSessionRequest = try ATProtoHTTPRequest(host: host,
                                                               nsid: refreshSessionLexicon.id,
                                                               parameters: [:],
                                                               body: nil,
                                                               token: refreshToken,
                                                               requestable: procedure)

            let refreshSessionResult: Result<RefreshSessionResponseBody, ATProtoHTTPClientError<RefreshSessionError>> = await ATProtoHTTPClient.make(request: refreshSessionRequest)

            switch refreshSessionResult {
            case .success(let refreshSessionResponse):
                return .success(refreshSessionResponse)

            case .failure(let error):
                return .failure(ClientError(atProtoHTTPClientError: error))
            }

        default:
            return .failure(.invalidLexicon)
        }
    }
}
