//
//  DeleteLike.swift
//  SwiftBluesky
//
//  Created by Christopher Head on 11/10/24.
//

import Foundation
import SwiftATProto

public extension Bsky.Feed {
    @available(iOS 16.0, *)
    static func deleteLike(host: URL,
                           accessToken: String,
                           refreshToken: String,
                           repo: String,
                           rkey: String)
    async -> Result<(body: ATProto.Repo.DeleteRecordResponseBody,
                     credentials: (accessToken: String,
                                   refreshToken: String)?),
                    BlueskyClientError<ATProto.Repo.DeleteRecordError>> {
        return await ATProto.Repo.deleteRecord(host: host,
                                               accessToken: accessToken,
                                               refreshToken: refreshToken,
                                               repo: repo, collection: "app.bsky.feed.like",
                                               rkey: rkey)
    }
}
