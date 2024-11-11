//
//  GetPosts.swift
//  SwiftBluesky
//
//  Created by Christopher Head on 11/10/24.
//

import Foundation

public extension Bsky.Feed {
    struct GetPostsResponseBody: Decodable {
        let posts: [PostView]
    }

    struct GetPostsError: Decodable, Error {

    }

    @available(iOS 16.0, *)
    static func getPosts(host: URL,
                         accessToken: String,
                         refreshToken: String,
                         uris: [String])
    async throws -> Result<(body: GetPostsResponseBody,
                            credentials: (accessToken: String,
                                          refreshToken: String)?),
                            ClientError<GetPostsError>> {
        try await Client.makeRequest(lexicon: "app.bsky.feed.getPosts",
                              host: host,
                              credentials: (accessToken, refreshToken),
                              body: nil as String?,
                              parameters: ["uris" : uris])
    }
}
