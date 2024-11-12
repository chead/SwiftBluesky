//
//  CreateRecord.swift
//  SwiftBluesky
//
//  Created by Christopher Head on 11/10/24.
//

import Foundation

public extension ATProto.Repo {
    internal struct CreateRecordRequestBody<Record: Encodable>: Encodable {
        let repo: String
        let collection: String
        let record: Record
    }

    struct CreateRecordResponseBody: Decodable {
        public let uri: String
        public let cid: String
    }
    
    enum CreateRecordError: String, Decodable, Error {
        case invalidSwap = "InvalidSwap"
    }

    @available(iOS 16.0.0, *)
    static func createRecord<Record: Encodable>(host: URL,
                                                accessToken: String,
                                                refreshToken: String,
                                                repo: String,
                                                collection: String,
                                                record: Record)
    async -> Result<(body: CreateRecordResponseBody,
                            credentials: (accessToken: String,
                                          refreshToken: String)?),
                           BlueskyClientError<CreateRecordError>> {
        let createRecordRequestBody = CreateRecordRequestBody(repo: repo,
                                                              collection: collection,
                                                              record: record)

        return await Client.makeRequest(lexicon: "com.atproto.repo.createRecord",
                                        host: host,
                                        credentials: (accessToken, refreshToken),
                                        body: createRecordRequestBody,
                                        parameters: [:])
    }
}
