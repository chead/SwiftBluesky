//
//  UploadBlob.swift
//  SwiftBluesky
//
//  Created by Christopher Head on 11/10/24.
//

import Foundation
import SwiftATProto

public extension ATProto.Repo {
    struct UploadBlobResponseBody: Decodable {
        let blob: ATProtoBlob
    }

    struct UploadBlobError: Decodable, Error {

    }

    @available(iOS 16.0, *)
    static func uploadBlob(host: URL,
                           accessToken: String,
                           refreshToken: String,
                           blob: Data,
                           encoding: String? = nil)
    async throws -> Result<(body: UploadBlobResponseBody,
                            credentials: (accessToken: String,
                                          refreshToken: String)?),
                           BlueskyClientError<UploadBlobError>> {
        return try await Client.makeRequest(lexicon: "com.atproto.repo.uploadBlob",
                                            host: host,
                                            credentials: (accessToken, refreshToken),
                                            body: blob,
                                            parameters: [:],
                                            encoding: encoding)
    }
}
