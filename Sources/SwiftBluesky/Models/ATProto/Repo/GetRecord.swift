//
//  GetRecord.swift
//  SwiftBluesky
//
//  Created by Christopher Head on 11/10/24.
//

import Foundation

public extension ATProto.Repo {
    struct GetRecordResponseBody<Record: Decodable>: Decodable {
        public let uri: String
        public let cid: String?
        public let value: Record
    }

    enum GetRecordError: String, Decodable, Error {
        case recordNotFound = "RecordNotFound"
    }

    @available(iOS 16.0, *)
    static func getRecord<Record: Decodable>(host: URL,
                                             accessToken: String,
                                             refreshToken: String,
                                             repo: String,
                                             collection: String,
                                             rkey: String,
                                             cid: String? = nil)
    async -> Result<(body: GetRecordResponseBody<Record>,
                     credentials: (accessToken: String,
                                   refreshToken: String)?),
                    BlueskyClientError<GetRecordError>>
    {
        return await Client.makeRequest(lexicon: "com.atproto.repo.getRecord",
                                        host: host,
                                        credentials: (accessToken, refreshToken),
                                        body: nil as String?,
                                        parameters: ["repo" : repo,
                                                     "collection" : collection,
                                                     "rkey" : rkey,
                                                     "cid" : cid])
    }
}
