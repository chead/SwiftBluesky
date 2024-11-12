//
//  CreateLike.swift
//  SwiftBluesky
//
//  Created by Christopher Head on 11/10/24.
//

import Foundation
import SwiftATProto

public extension Bsky.Feed {
    @available(iOS 16.0.0, *)
    static func createLike(host: URL,
                           accessToken: String,
                           refreshToken: String,
                           repo: String,
                           uri: String,
                           cid: String)
    async -> Result<(body: ATProto.Repo.CreateRecordResponseBody,
                     credentials: (accessToken: String,
                                   refreshToken: String)?),
                    BlueskyClientError<ATProto.Repo.CreateRecordError>> {
        let like = Like(subject: ATProtoRepoStrongRef(uri: uri,
                                                      cid: cid),
                        createdAt: Date())

        return await ATProto.Repo.createRecord(host: host,
                                               accessToken: accessToken,
                                               refreshToken: refreshToken,
                                               repo: repo,
                                               collection: "app.bsky.feed.like",
                                               record: like)
    }
}
