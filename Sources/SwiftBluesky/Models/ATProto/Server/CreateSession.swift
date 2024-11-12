//
//  CreateSession.swift
//  SwiftBluesky
//
//  Created by Christopher Head on 11/10/24.
//

import Foundation
import SwiftATProto
import SwiftLexicon

public extension ATProto.Server {
    internal struct CreateSessionRequestBody: Encodable {
        public let identifier: String
        public let password: String

        public init(identifier: String, password: String) {
            self.identifier = identifier
            self.password = password
        }
    }

    struct CreateSessionResponseBody: Decodable {
        public let did: String
        public let handle: String
        public let accessJwt: String
        public let refreshJwt: String
    }

    enum CreateSessionError: String, Decodable, Error {
        case accountTakedown = "AccountTakedown"
        case authFactorTokenRequired = "AuthFactorTokenRequired"
    }

    @available(iOS 16.0, *)
    static func createSession(host: URL, identifier: String, password: String) async -> Result<CreateSessionResponseBody, BlueskyClientError<CreateSessionError>> {
        guard let lexiconURL = Bundle.module.url(forResource: "com.atproto.server.createSession", withExtension: "json"),
              let lexiconData = try? Data(contentsOf: lexiconURL),
              let createSessionLexicon = try? JSONDecoder().decode(Lexicon.self, from: lexiconData) else {
            return .failure(.invalidLexicon)
        }

        switch createSessionLexicon.defs["main"] {
        case .procedure(let procedure):
            let createSessionRequestBody = CreateSessionRequestBody(identifier: identifier,
                                                                    password: password)

            guard let createSessionRequest = try? ATProtoHTTPRequest(host: host,
                                                                     nsid: createSessionLexicon.id,
                                                                     parameters: [:],
                                                                     body: createSessionRequestBody,
                                                                     token: nil,
                                                                     requestable: procedure)
            else {
                return .failure(.invalidLexicon)
            }

            let createSessionResult: Result<CreateSessionResponseBody?, ATProtoHTTPClientError<CreateSessionError>> = await ATProtoHTTPClient.make(request: createSessionRequest)

            switch createSessionResult {
            case .success(let createSessionResponse):
                guard let createSessionResponse = createSessionResponse else {
                    return .failure(.invalidResponse)
                }

                return .success(createSessionResponse)

            case .failure(let createSessionError):
                return .failure(.atProtoClient(error: createSessionError))
            }

        default:
            return .failure(.invalidRequest)
        }
    }
}
