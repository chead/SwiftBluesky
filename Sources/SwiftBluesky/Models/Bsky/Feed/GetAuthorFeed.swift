//
//  GetAuthorFeed.swift
//  SwiftBluesky
//
//  Created by Christopher Head on 11/10/24.
//

import Foundation

public extension Bsky.Feed {
    enum GetAuthorFeedFilter: String {
        case postsWithReplies = "posts_with_replies"
        case postsNoReplies = "posts_no_replies"
        case postsWithMedia = "posts_with_media"
        case postsAndAuthorThreads = "posts_and_author_threads"
    }

    struct GetAuthorFeedResponseBody: Decodable {
        public let feed: [FeedViewPost]
    }

    enum GetAuthorFeedError: String, Decodable, Error {
        case blockedActor = "BlockedActor"
        case blockedByActor = "BlockedByActor"
    }

    @available(iOS 16.0, *)
    static func getAuthorFeed(host: URL,
                              accessToken: String,
                              refreshToken: String,
                              actor: String,
                              filter: GetAuthorFeedFilter? = nil,
                              limit: Int? = nil,
                              cursor: Date? = nil)
    async throws -> Result<(body: GetAuthorFeedResponseBody,
                            credentials: (accessToken: String,
                                          refreshToken: String)?),
                           BlueskyClientError<GetAuthorFeedError>>
    {
        var properties: [String : Encodable] = ["actor" : actor]

        if let filter = filter {
            properties["filter"] = filter.rawValue
        }

        if let cursor = cursor {
            properties["curor"] = ISO8601DateFormatter().string(from: cursor)
        }

        return try await Client.makeRequest(lexicon: "app.bsky.feed.getAuthorFeed",
                                            host: host,
                                            credentials: (accessToken, refreshToken),
                                            body: nil as String?,
                                            parameters: properties)
    }
}
