//
//  Client.swift
//  SwiftBluesky
//
//  Created by Christopher Head on 11/10/24.
//

import Foundation
import SwiftLexicon
import SwiftATProto

public enum BlueskyClientError<MethodError: Decodable>: Error {
    case badRequest(error: ATProtoHTTPClientBadRequestType<MethodError>, message: String)
    case badResponse(error: Error)
    case noResponse
    case unauthorized
    case forbidden
    case notFound
    case largePayload
    case tooManyRequests
    case internalServerError
    case notImplemented
    case unavailable
    case session(error: Error)
    case unknown(status: Int)
    case invalidRequest
    case invalidResponse
    case invalidLexicon

    init(atProtoHTTPClientError: ATProtoHTTPClientError<MethodError>) {
        switch(atProtoHTTPClientError) {
        case .badRequest(let error, let message):
            self = .badRequest(error: error, message: message)

        case .badResponse(let error):
            self = .badResponse(error: error)

        case .noResponse:
            self = .noResponse

        case .unauthorized:
            self = .unauthorized

        case .forbidden:
            self = .forbidden

        case .notFound:
            self = .notFound

        case .largePayload:
            self = .largePayload

        case .tooManyRequests:
            self = .tooManyRequests

        case .internalServerError:
            self = .internalServerError

        case .notImplemented:
            self = .notImplemented

        case .unavailable:
            self = .unavailable

        case .session(let error):
            self = .session(error: error)

        case .unknown(let status):
            self = .unknown(status: status)
        }
    }
}

internal final class Client {
    @available(iOS 16.0, *)
    internal static func makeRequest<RequestBody: Encodable, ResponseBody: Decodable, MethodError: Decodable>(lexicon: String, host: URL, credentials: (accessToken: String, refreshToken: String)? = nil, body: RequestBody?, parameters: [String : any Encodable], encoding: String? = nil, retry: Bool = true) async throws -> Result<(body: ResponseBody, credentials: (accessToken: String, refreshToken: String)?), BlueskyClientError<MethodError>> {
        let requestLexicon = try JSONDecoder().decode(Lexicon.self, from: try Data(contentsOf: Bundle.module.url(forResource: lexicon, withExtension: "json")!))

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
                                             token: credentials?.accessToken,
                                             requestable: requestable,
                                             encoding: encoding)

        let response: Result<ResponseBody, ATProtoHTTPClientError<MethodError>> = await ATProtoHTTPClient.make(request: request)

        switch response {
        case .success(let result):
            return .success((body: result,
                             credentials: retry == false ? credentials : nil))

        case .failure(let error):
            switch(error) {
            case .badRequest(error: let requestError):
                switch(requestError.error) {
                case .request(let blueskyRequestError):
                    switch(blueskyRequestError) {
                    case .expiredToken:
                        if retry, let credentials = credentials {
                            switch(try await ATProto.Server.refreshSession(host: host,
                                                                   refreshToken: credentials.refreshToken)) {
                            case .success(let refreshSessionResponse):
                                return try await makeRequest(lexicon: lexicon,
                                                             host: host,
                                                             credentials: (refreshSessionResponse.accessJwt,
                                                                           refreshSessionResponse.refreshJwt),
                                                             body: body,
                                                             parameters: parameters,
                                                             retry: false)

                            default:
                                break
                            }
                        }

                        return .failure(BlueskyClientError(atProtoHTTPClientError: error))

                    default:
                        return .failure(BlueskyClientError(atProtoHTTPClientError: error))
                    }

                default:
                    return .failure(BlueskyClientError(atProtoHTTPClientError: error))
                }

            default:
                return .failure(BlueskyClientError(atProtoHTTPClientError: error))
            }
        }
    }
}
