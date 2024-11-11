//
//  GetLists.swift
//  SwiftBluesky
//
//  Created by Christopher Head on 11/10/24.
//

import Foundation

public extension Bsky.Graph {
    struct GetListsResponseBody: Decodable {
        public let lists: [ListViewBasic]
    }

    struct GetListsError: Decodable, Error {

    }

    @available(iOS 16.0, *)
    static func getLists(host: URL,
                         accessToken: String,
                         refreshToken: String,
                         actor: String,
                         limit: Int?,
                         cursor: Date?)
    async throws -> Result<(body: GetListsResponseBody,
                            credentials: (accessToken: String,
                                          refreshToken: String)?),
                           BlueskyClientError<GetListsError>> {
        var parameters: [String : Encodable] = ["actor" : actor]

        if let limit = limit {
            parameters["limit"] = limit
        }

        if let cursor = cursor {
            parameters["cursor"] = ISO8601DateFormatter().string(from: cursor)
        }

        return try await Client.makeRequest(lexicon: "app.bsky.graph.getLists",
                                            host: host,
                                            credentials: (accessToken, refreshToken),
                                            body: nil as String?,
                                            parameters: parameters)
    }
}
