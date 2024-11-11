//
//  MuteThread.swift
//  SwiftBluesky
//
//  Created by Christopher Head on 11/10/24.
//

import Foundation

public extension Bsky.Graph {
    internal struct MuteThreadRequestBody: Encodable {
        let root: String
    }

    struct MuteThreadResponseBody: Decodable {

    }

    struct MuteThreadError: Decodable, Error {

    }

    @available(iOS 16.0, *)
    static func muteThread(host: URL,
                           accessToken: String,
                           refreshToken: String,
                           root: String)
    async throws -> Result<(body: MuteThreadResponseBody,
                            credentials: (accessToken: String,
                                          refreshToken: String)?),
                           BlueskyClientError<MuteThreadError>>
    {
        let muteThreadRequestBody = MuteThreadRequestBody(root: root)

        return try await Client.makeRequest(lexicon: "app.bsky.graph.muteThread",
                                            host: host,
                                            credentials: (accessToken, refreshToken),
                                            body: muteThreadRequestBody,
                                            parameters: [:])
    }
}
