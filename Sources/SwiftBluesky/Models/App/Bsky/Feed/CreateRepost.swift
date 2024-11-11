//
//  CreateRepost.swift
//  SwiftBluesky
//
//  Created by Christopher Head on 11/10/24.
//

import Foundation
import SwiftATProto

public extension BskyApp.Bsky.Feed {
    @available(iOS 16.0.0, *)
    static func createRepost(host: URL,
                             accessToken: String,
                             refreshToken: String,
                             repo: String,
                             uri: String,
                             cid: String)
    async throws -> Result<(body: Com.ATProto.Repo.CreateRecordResponseBody,
                            credentials: (accessToken: String,
                                          refreshToken: String)?),
                            ClientError<Com.ATProto.Repo.CreateRecordError>> {
        let repost = Repost(subject: ATProtoRepoStrongRef(uri: uri,
                                                          cid: cid),
                            createdAt: Date())

        return try await Com.ATProto.Repo.createRecord(host: host,
                                                       accessToken: accessToken,
                                                       refreshToken: refreshToken,
                                                       repo: repo,
                                                       collection: "app.bsky.feed.repost",
                                                       record: repost)
    }
}
