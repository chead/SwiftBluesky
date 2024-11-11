//
//  getProfile.swift
//  SwiftBluesky
//
//  Created by Christopher Head on 11/10/24.
//

import Foundation

public extension Bsky.BskyActor {
    struct GetProfileError: Decodable, Error {

    }

    @available(iOS 16.0.0, *)
    static func getProfile(host: URL,
                            accessToken: String,
                            refreshToken: String,
                            actor: String)
    async throws -> Result<(body: ProfileViewDetailed,
                            credentials: (accessToken: String,
                                          refreshToken: String)?),
                           BlueskyClientError<GetProfileError>>
    {
        try await Client.makeRequest(lexicon: "app.bsky.actor.getProfile",
                                     host: host,
                                     credentials: (accessToken, refreshToken),
                                     body: nil as String?,
                                     parameters: ["actor" : actor])
    }
}
