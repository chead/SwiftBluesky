//
//  DeleteLike.swift
//  SwiftBluesky
//
//  Created by Christopher Head on 11/10/24.
//

import Foundation
import SwiftATProto

public extension BskyApp.Bsky.Feed {
    @available(iOS 16.0, *)
    static func deleteLike(host: URL,
                           accessToken: String,
                           refreshToken: String,
                           repo: String,
                           rkey: String)
    async throws -> Result<(body: Com.ATProto.Repo.DeleteRecordResponseBody,
                            credentials: (accessToken: String,
                                          refreshToken: String)?),
                           ClientError<Com.ATProto.Repo.DeleteRecordError>> {
        return try await Com.ATProto.Repo.deleteRecord(host: host,
                                                       accessToken: accessToken,
                                                       refreshToken: refreshToken,
                                                       repo: repo, collection: "app.bsky.feed.like",
                                                       rkey: rkey)
    }
}
