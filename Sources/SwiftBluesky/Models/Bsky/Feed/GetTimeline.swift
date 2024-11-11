//
//  GetTimeline.swift
//  SwiftBluesky
//
//  Created by Christopher Head on 11/10/24.
//

import Foundation

public extension Bsky.Feed {
    struct GetTimelineResponseBody: Decodable {
        public let cursor: String
        public let feed: [FeedViewPost]
    }

    struct GetTimelineError: Decodable, Error {

    }

    @available(iOS 16.0, *)
    static func getTimeline(host: URL,
                            accessToken: String,
                            refreshToken: String,
                            algorithm: String,
                            limit: Int,
                            cursor: Date)
    async throws -> Result<(body: GetTimelineResponseBody,
                            credentials: (accessToken: String,
                                          refreshToken: String)?),
                           BlueskyClientError<GetTimelineError>>
    {
        try await Client.makeRequest(lexicon: "app.bsky.feed.getTimeline",
                                     host: host,
                                     credentials: (accessToken, refreshToken),
                                     body: nil as String?,
                                     parameters: ["algorithm" : algorithm,
                                                  "limit" : limit,
                                                  "cursor" : ISO8601DateFormatter().string(from: cursor)])
    }
}
