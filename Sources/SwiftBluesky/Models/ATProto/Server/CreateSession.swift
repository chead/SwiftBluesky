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
    static func createSession(host: URL, identifier: String, password: String) async throws -> Result<CreateSessionResponseBody, ClientError<CreateSessionError>> {
        let createSessionLexicon = try JSONDecoder().decode(Lexicon.self,
                                                            from: try Data(contentsOf: Bundle.module.url(forResource: "com.atproto.server.createSession",
                                                                                                         withExtension: "json")!))

        if let mainDef = createSessionLexicon.defs["main"] {
            switch mainDef {
            case .procedure(let procedure):
                let createSessionRequestBody = CreateSessionRequestBody(identifier: identifier, password: password)

                let createSessionRequest = try ATProtoHTTPRequest(host: host,
                                                                  nsid: createSessionLexicon.id,
                                                                  parameters: [:],
                                                                  body: createSessionRequestBody,
                                                                  token: nil,
                                                                  requestable: procedure)

                let createSessionResult: Result<CreateSessionResponseBody?, ATProtoHTTPClientError<CreateSessionError>> = await ATProtoHTTPClient.make(request: createSessionRequest)

                switch createSessionResult {
                case .success(let createSessionResponse):
                    guard let createSessionResponse = createSessionResponse else {
                        return .failure(.invalidResponse)
                    }

                    return .success(createSessionResponse)

                case .failure(let error):
                    return .failure(ClientError(atProtoHTTPClientError: error))
                }

            default:
                return .failure(.invalidRequest)
            }
        }

        return .failure(.invalidLexicon)
    }
}
