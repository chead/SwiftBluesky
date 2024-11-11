//
//  PutRecord.swift
//  SwiftBluesky
//
//  Created by Christopher Head on 11/10/24.
//

import Foundation

public extension ATProto.Repo {
    internal struct PutRecordRequestBody<Record: Encodable>: Encodable {
        let repo: String
        let collection: String
        let rkey: String
        let validate: Bool?
        let record: Record
        let swapRecord: String?
        let swapCommit: String?
    }

    struct PutRecordResponseBody: Decodable {
        public enum ValidationStatus: String, Decodable {
            case valid
            case unknown
        }

        public let uri: String
        public let cid: String
        public let commit: CommitMeta?
        public let validationStatus: ValidationStatus
    }

    enum PutRecordError: String, Decodable, Error {
        case invalidSwap = "InvalidSwap"
    }

    @available(iOS 16.0.0, *)
    static func putRecord<Record: Encodable>(host: URL,
                                             accessToken: String,
                                             refreshToken: String,
                                             repo: String,
                                             collection: String,
                                             rkey: String,
                                             validate: Bool? = nil,
                                             record: Record,
                                             swapRecord: String? = nil,
                                             swapCommit: String? = nil)
    async throws -> Result<(body: PutRecordResponseBody,
                            credentials: (accessToken: String,
                                          refreshToken: String)?),
                           ClientError<PutRecordError>> {
        let putRecordRequestBody = PutRecordRequestBody(repo: repo,
                                                        collection: collection,
                                                        rkey: rkey,
                                                        validate: validate,
                                                        record: record,
                                                        swapRecord: swapRecord,
                                                        swapCommit: swapCommit)

        return try await Client.makeRequest(lexicon: "com.atproto.repo.putRecord",
                                            host: host,
                                            credentials: (accessToken, refreshToken),
                                            body: putRecordRequestBody,
                                            parameters: [:])
    }
}
