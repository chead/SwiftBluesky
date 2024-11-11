//
//  GetPostThread.swift
//  SwiftBluesky
//
//  Created by Christopher Head on 11/10/24.
//

import Foundation

public extension Bsky.Feed {
    struct GetPostThreadResponseBody: Decodable {
        public let thread: ThreadViewPost
    }

    enum GetPostThreadError: String, Decodable, Error {
        case notFound = "NotFound"
    }

    @available(iOS 16.0, *)
    static func getPostThread(host: URL,
                              accessToken: String,
                              refreshToken: String,
                              uri: String,
                              depth: Int? = nil,
                              parentHeight: Int? = nil)
    async throws -> Result<(body: GetPostThreadResponseBody,
                            credentials: (accessToken: String,
                                          refreshToken: String)?),
                           BlueskyClientError<GetPostThreadError>>
    {
        var properties: [String : Encodable] = ["uri" :  uri]

        if let depth = depth {
            properties["depth"] = depth
        }

        if let parentHeight = parentHeight {
            properties["parentHeight"] = parentHeight
        }

        return try await Client.makeRequest(lexicon: "app.bsky.feed.getPostThread",
                                            host: host,
                                            credentials: (accessToken, refreshToken),
                                            body: nil as String?,
                                            parameters: properties)
    }
}
