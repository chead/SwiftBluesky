//
//  DeleteRecord.swift
//  SwiftBluesky
//
//  Created by Christopher Head on 11/10/24.
//

import Foundation

public extension ATProto.Repo {
    internal struct DeleteRecordRequestBody: Encodable {
        let repo: String
        let collection: String
        let rkey: String
    }

    struct DeleteRecordResponseBody: Decodable {

    }

    enum DeleteRecordError: String, Decodable, Error {
        case invalidSwap = "InvalidSwap"
    }

    @available(iOS 16.0, *)
    static func deleteRecord(host: URL,
                             accessToken: String,
                             refreshToken: String,
                             repo: String,
                             collection: String,
                             rkey: String)
    async throws -> Result<(body: DeleteRecordResponseBody,
                            credentials: (accessToken: String,
                                          refreshToken: String)?),
                           BlueskyClientError<DeleteRecordError>> {
        let deleteRecordRequestBody = DeleteRecordRequestBody(repo: repo,
                                                              collection: collection,
                                                              rkey: rkey)

        return try await Client.makeRequest(lexicon: "com.atproto.repo.deleteRecord",
                                            host: host,
                                            credentials: (accessToken, refreshToken),
                                            body: deleteRecordRequestBody,
                                            parameters: [:])
    }
}
