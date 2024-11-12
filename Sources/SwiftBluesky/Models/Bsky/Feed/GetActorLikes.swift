//
//  GetActorLikes.swift
//  SwiftBluesky
//
//  Created by Christopher Head on 11/10/24.
//

import Foundation

public extension Bsky.Feed {
    struct GetActorLikesResponseBody: Decodable {
        public let feed: [FeedViewPost]
    }

    enum GetActorLikesError: String, Decodable, Error {
        case blockedActor = "BlockedActor"
        case blockedByActor = "BlockedByActor"
    }

    @available(iOS 16.0, *)
    static func getActorLikes(host: URL,
                              accessToken: String,
                              refreshToken: String,
                              actor: String,
                              limit: Int?,
                              cursor: Date?)
    async -> Result<(body: GetActorLikesResponseBody,
                            credentials: (accessToken: String,
                                          refreshToken: String)?),
                           BlueskyClientError<GetActorLikesError>>
    {
        var properties: [String : Encodable] = ["actor" : actor]

        if let limit = limit {
            properties["limit"] = limit
        }

        if let cursor = cursor {
            properties["cursor"] = cursor
        }

        return await Client.makeRequest(lexicon: "app.bsky.feed.getActorLikes",
                                        host: host,
                                        credentials: (accessToken, refreshToken),
                                        body: nil as String?,
                                        parameters: properties)
    }
}
