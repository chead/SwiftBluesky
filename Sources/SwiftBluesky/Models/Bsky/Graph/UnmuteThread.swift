//
//  UnmuteThread.swift
//  SwiftBluesky
//
//  Created by Christopher Head on 11/10/24.
//

import Foundation

public extension Bsky.Graph {
    internal struct UnmuteThreadRequestBody: Encodable {
        let root: String
    }

    struct UnmuteThreadReponseBody: Decodable {

    }

    struct UnmuteThreadError: Decodable, Error {

    }

    @available(iOS 16.0, *)
    static func unmuteThread(host: URL,
                             accessToken: String,
                             refreshToken: String,
                             root: String)
    async throws -> Result<(body: UnmuteThreadReponseBody,
                            credentials: (accessToken: String,
                                          refreshToken: String)?),
                           BlueskyClientError<UnmuteThreadError>> {
        let unmuteThreadRequestBody = UnmuteThreadRequestBody(root: root)

        return try await Client.makeRequest(lexicon: "app.bsky.graph.unmuteThread",
                                            host: host,
                                            credentials: (accessToken, refreshToken),
                                            body: unmuteThreadRequestBody,
                                            parameters: [:])
    }
}
