//
//  UploadBlobTests.swift
//  SwiftBluesky
//
//  Created by Christopher Head on 11/11/24.
//

import XCTest
@testable import SwiftBluesky

final class UploadBlobTests: XCTestCase {
    @available(iOS 16.0, *)
    func testUploadBlob() async {
        let blobURL = Bundle.module.url(forResource: "right", withExtension: "jpg")!
        let blobData = try! Data(contentsOf: blobURL)
        let host = URL(string: "https://bsky.social")!

        switch(await ATProto.Server.createSession(host: host,
                                                  identifier: "osmote.net",
                                                  password: "HANDCAR-weaponry-monk")) {
        case .success(let createSessionResponseBody):
            switch(await ATProto.Repo.uploadBlob(host: host,
                                                 accessToken: createSessionResponseBody.accessJwt,
                                                 refreshToken: createSessionResponseBody.refreshJwt,
                                                 blob: blobData)) {
            case .success(let uploadBlobResponseBody):
                try! Data(contentsOf: URL(string: "https://bsky.social/xrpc/com.atproto.sync.getBlob?did=\(createSessionResponseBody.did)&cid=\(uploadBlobResponseBody.body.blob.ref.link)")!)

            case .failure(_):
                break

            }

        case .failure(_):
            break
        }
    }
}

//    @available(iOS 16.0, *)
//    func testUploadBlob() async throws {
//        let blobURL = Bundle.module.url(forResource: "right", withExtension: "jpg")!
//        let blobData = try Data(contentsOf: blobURL)
//
//        let host = URL(string: "https://bsky.social")!
//        let accessToken = "eyJ0eXAiOiJhdCtqd3QiLCJhbGciOiJFUzI1NksifQ.eyJzY29wZSI6ImNvbS5hdHByb3RvLmFjY2VzcyIsInN1YiI6ImRpZDpwbGM6ZXRkY2I0N3Y1NG13djJ3ZHVmaGk0dHU2IiwiaWF0IjoxNzMwNTkxNjEzLCJleHAiOjE3MzA1OTg4MTMsImF1ZCI6ImRpZDp3ZWI6ZW5va2kudXMtZWFzdC5ob3N0LmJza3kubmV0d29yayJ9.B3YjMQQr9iC4Znb-jsULy0x1aDO9iHYcus3bZ8WRrXWXkhM2T5GfO__nrpeR_AZrFS0FxDbpWiXTzr6dPTe3aw"
//        let refreshToken = "eyJ0eXAiOiJyZWZyZXNoK2p3dCIsImFsZyI6IkVTMjU2SyJ9.eyJzY29wZSI6ImNvbS5hdHByb3RvLnJlZnJlc2giLCJzdWIiOiJkaWQ6cGxjOmV0ZGNiNDd2NTRtd3Yyd2R1ZmhpNHR1NiIsImF1ZCI6ImRpZDp3ZWI6YnNreS5zb2NpYWwiLCJqdGkiOiIxZVRlSFRoYmpkeFYraWU1SkhyZ2hlSENJYm1KMUZuUWkwUHFSRUJwM2JFIiwiaWF0IjoxNzMwNTkxNjEzLCJleHAiOjE3MzgzNjc2MTN9.I4Jjh7K9m4C3Gxj8snS1YyycgptI6e9kte7zQ1K-ze_znu0MHD1OF9_ZHeJWFLwUjoQD3KDs-PaTnnHGy5Kh8g"
//
//        let uploadBlobResponse = try await BlueskyClient.Repo.uploadBlob(host: host, accessToken: accessToken, refreshToken: refreshToken, blob: blobData)
//
//        switch(uploadBlobResponse) {
//        case .success(let uploadBlobResponseValue):
//            break
//
//        case .failure(_):
//            break
//        }
//    }
