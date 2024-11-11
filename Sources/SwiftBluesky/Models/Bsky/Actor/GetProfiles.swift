//
//  getProfiles.swift
//  SwiftBluesky
//
//  Created by Christopher Head on 11/10/24.
//

import Foundation

public extension Bsky.BskyActor {
    struct GetProfilesResponseBody: Decodable {
        public let profiles: [ProfileViewDetailed]
    }

    struct GetProfilesError: Decodable, Error {

    }

    @available(iOS 16.0, *)
    static func getProfiles(host: URL,
                            accessToken: String,
                            refreshToken: String,
                            actors: [String])
    async throws -> Result<(body: GetProfilesResponseBody,
                            credentials: (accessToken: String,
                                          refreshToken: String)?),
                           ClientError<GetProfilesError>> {
        try await Client.makeRequest(lexicon: "app.bsky.actor.getProfiles",
                              host: host,
                              credentials: (accessToken, refreshToken),
                              body: nil as String?,
                              parameters: ["actors" : actors])
    }
}
