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
    case invalidRequest
    case invalidResponse
    case lexiconNotFound
    case invalidLexicon
    case atProtoClient(error: ATProtoHTTPClientError<MethodError>)
}

internal class Client {
    @available(iOS 16.0, *)
    internal static func makeRequest<RequestBody: Encodable, ResponseBody: Decodable, MethodError: Decodable>(
        lexicon: String,
        host: URL,
        credentials: (accessToken: String,
                      refreshToken: String)? = nil,
        body: RequestBody?,
        parameters: [String : any Encodable],
        encoding: String? = nil,
        retry: Bool = true)
    async -> Result<(body: ResponseBody,
                     credentials: (accessToken: String,
                                   refreshToken: String)?), BlueskyClientError<MethodError>> {
        guard let lexiconURL = Bundle.module.url(forResource: lexicon, withExtension: "json"),
              let lexiconData = try? Data(contentsOf: lexiconURL),
              let requestLexicon = try? JSONDecoder().decode(Lexicon.self, from: lexiconData) else {
            return .failure(.invalidLexicon)
        }

        var requestable: (any LexiconHTTPRequestable)?

        switch requestLexicon.defs["main"] {
        case .query(let lexiconQuery):
            requestable = lexiconQuery

        case .procedure(let lexiconProcedure):
            requestable = lexiconProcedure

        default:
            return .failure(.invalidLexicon)
        }

        guard let requestable = requestable else {
            return .failure(.invalidLexicon)
        }

        guard let request = try? ATProtoHTTPRequest(host: host,
                                                    nsid: requestLexicon.id,
                                                    parameters: parameters,
                                                    body: body,
                                                    token: credentials?.accessToken,
                                                    requestable: requestable,
                                                    encoding: encoding) else {
            return .failure(.invalidRequest)
        }

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
                            switch(await ATProto.Server.refreshSession(host: host,
                                                                       refreshToken: credentials.refreshToken)) {
                            case .success(let refreshSessionResponse):
                                return await makeRequest(lexicon: lexicon,
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

                    default:
                        break
                    }

                default:
                    return .failure(.badRequest(error: requestError.error, message: requestError.message))
                }

            default:
                break
            }

            return .failure(.atProtoClient(error: error))
        }
    }
}
