//
//  getProfile.swift
//  SwiftBluesky
//
//  Created by Christopher Head on 11/10/24.
//

import Foundation

public extension BskyApp.Bsky.BskyActor {
    @available(iOS 16.0.0, *)
    static func getProfile(host: URL, accessToken: String, refreshToken: String, actor: String) async throws -> Result<(body: Profile, credentials: (accessToken: String, refreshToken: String)?), ClientError<Com.ATProto.Repo.GetRecordError>> {
        let result: Result<(body: Com.ATProto.Repo.GetRecordResponseBody<Profile>,
                            credentials: (accessToken: String, refreshToken: String)?),
                            ClientError<Com.ATProto.Repo.GetRecordError>> =
        try await Com.ATProto.Repo.getRecord(host: host,
                                             accessToken: accessToken,
                                             refreshToken: refreshToken,
                                             repo: actor,
                                             collection: "app.bsky.actor.profile",
                                             rkey: "self")

        switch(result) {
        case .success(let value):
            return .success((body: value.body.value, credentials: value.credentials))

        case .failure(let error):
            return .failure(error)
        }
    }
}
