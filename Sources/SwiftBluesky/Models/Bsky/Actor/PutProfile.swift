//
//  PutProfile.swift
//  SwiftBluesky
//
//  Created by Christopher Head on 11/10/24.
//

import Foundation

public extension Bsky.BskyActor {
    @available(iOS 16.0.0, *)
    static func putProfile(host: URL,
                           accessToken: String,
                           refreshToken: String,
                           repo: String,
                           profile: Profile)
    async throws -> Result<(body: ATProto.Repo.PutRecordResponseBody,
                            credentials: (accessToken: String, refreshToken: String)?),
                           BlueskyClientError<ATProto.Repo.PutRecordError>> {
        return try await ATProto.Repo.putRecord(host: host,
                                                    accessToken: accessToken,
                                                    refreshToken: refreshToken,
                                                    repo: repo,
                                                    collection: "app.bsky.actor.profile",
                                                    rkey: "self",
                                                    record: profile)
    }
}
