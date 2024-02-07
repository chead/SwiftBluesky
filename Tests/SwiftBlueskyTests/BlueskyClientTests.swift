import XCTest
import SwiftATProto
@testable import SwiftBluesky

final class BlueskyClientTests: XCTestCase {
    @available(iOS 16.0, *)
    func testCreateSession() async throws {
        let blueskyClient = BlueskyClient()
        
        let createSessionResponse = try await blueskyClient.createSession(host: URL(string: "")!, identifier: "", password: "")

        switch createSessionResponse {
        case .success(let createSessionResponseValue):
            break

        case .failure(let error):
            break
        }
    }

    @available(iOS 16.0, *)
    func testGetProfiles() async throws {
        let blueskyClient = BlueskyClient()

        let getProfilesResponse = try await blueskyClient.getProfiles(host: URL(string: "")!, accessToken: "", refreshToken: "", actors: [])
        
//        switch createSessionResponse {
//        case .success(let createSessionResponseValue):
//            break
//
//        case .failure(_):
//            break
//        }
    }

    @available(iOS 16.0, *)
    func testGetAuthorFeed() async throws {
        let getAuthorFeedJSONDataURL = Bundle.module.url(forResource: "GetAuthorFeed", withExtension: "json")
        let getAuthorFeedJSONData = try! Data(contentsOf: getAuthorFeedJSONDataURL!)

        let timeline = try JSONDecoder().decode(BlueskyFeedGetAuthorFeedResponseBody.self, from: getAuthorFeedJSONData)
    }

    @available(iOS 16.0, *)
    func testRefreshSession() async throws {
        let blueskyClient = BlueskyClient()
        
        let refreshSessionResponse = try await blueskyClient.refreshSession(host: URL(string: "")!, refreshToken: "")

        switch refreshSessionResponse {
        case .success(let refreshSessionResponseValue):
            break

        case .failure(_):
            break
        }
    }

    @available(iOS 16.0, *)
    func testGetTimeline() async throws {
        let getTimelineJSONDataURL = Bundle.module.url(forResource: "GetTimeline", withExtension: "json")
        let getTimelineJSONData = try! Data(contentsOf: getTimelineJSONDataURL!)

        let timeline = try! JSONDecoder().decode(BlueskyFeedGetTimelineResponseBody.self, from: getTimelineJSONData)
//        let blueskyClient = BlueskyClient()
//
//        let getTimelineResponse = try await blueskyClient.getTimeline(host: URL(string: "https://bsky.social")!, accessToken: "eyJhbGciOiJFUzI1NksifQ.eyJzY29wZSI6ImNvbS5hdHByb3RvLmFjY2VzcyIsInN1YiI6ImRpZDpwbGM6ZXRkY2I0N3Y1NG13djJ3ZHVmaGk0dHU2IiwiaWF0IjoxNzA2NzIxNTU0LCJleHAiOjE3MDY3Mjg3NTQsImF1ZCI6ImRpZDp3ZWI6ZW5va2kudXMtZWFzdC5ob3N0LmJza3kubmV0d29yayJ9.nsm_mNxnNK3QWmW2ZPH_v798h00U4X13jAG6VlNet2pYbzzLiK0EtBj539Cuy5Dxe6j-uH-a8ZWFOKDFWlwMKw", refreshToken: "eyJhbGciOiJFUzI1NksifQ.eyJzY29wZSI6ImNvbS5hdHByb3RvLnJlZnJlc2giLCJzdWIiOiJkaWQ6cGxjOmV0ZGNiNDd2NTRtd3Yyd2R1ZmhpNHR1NiIsImF1ZCI6ImRpZDp3ZWI6YnNreS5zb2NpYWwiLCJqdGkiOiJmdG5oNlRwN2NVQUdnd1JoQTVVaHEvMTZCT0F6UW5NNVVrdjZiK2lMTVM0IiwiaWF0IjoxNzA2NzIxNTU0LCJleHAiOjE3MTQ0OTc1NTR9.oE2IwGoweM5XmX1Zf4YHn07SgqXbXFjwqRMctmZ9-xVHIJrg3LrkH34xwntPR_Jp55jkG3fy5_pIQFJ2txCe0g", algorithm: "", limit: 50, cursor: "")
//
    }

    func testImageBlob() throws {
        let imageBlobStringData =
        """
        {
            "alt": "Screenshot from King of the Hill Season 10, Episode 7",
            "image": {
                "cid": "bafkreib63e636m7knl6qq7szvwv6yu6f7sds42ziyo53hxha7zwkjjyw5q",
                "mimeType": "image/jpeg"
            }
        }
        """.data(using: .utf8)!

        let imageBlobStringJSON = try! JSONDecoder().decode(ATProtoImageBlob.self, from: imageBlobStringData)
    }

    func testThreadgateView() throws {
        let threadgateStringData =
        """
        {
            "uri": "at://did:plc:csm5nerxjfivn3gjblnb7cpl/app.bsky.feed.threadgate/3kk6ib2eax62v",
            "cid": "bafyreias4nctgaaoexjp2hhvcawexleivyirzjyycbr3lucsfmc5hsgcgq",
            "record": {
                "post": "at://did:plc:csm5nerxjfivn3gjblnb7cpl/app.bsky.feed.post/3kk6ib2eax62v",
                "$type": "app.bsky.feed.threadgate",
                "allow": [{
                    "$type": "app.bsky.feed.threadgate#followingRule"
                }],
                "createdAt": "2024-01-30T06:05:53.804Z"
            },
            "lists": []
        }
        """.data(using: .utf8)!

        let threadgateView = try! JSONDecoder().decode(BlueskyFeedThreadgateView.self, from: threadgateStringData)
    }

    @available(iOS 16.0, *)
    func testGetPostThread() async throws {
        let getPostThreadJSONDataURL = Bundle.module.url(forResource: "GetPostThread", withExtension: "json")
        let getPostThreadJSONData = try! Data(contentsOf: getPostThreadJSONDataURL!)

        let postThread = try JSONDecoder().decode(BlueskyFeedGetPostThreadResponseBody.self, from: getPostThreadJSONData)
    }

    @available(iOS 16.0, *)
    func testGetPosts() async throws {
//        let blueskyClient = BlueskyClient()
//
//        let getPostsResponse = try await blueskyClient.getPosts(host: URL(string: "https://bsky.social")!, accessToken: "eyJhbGciOiJFUzI1NksifQ.eyJzY29wZSI6ImNvbS5hdHByb3RvLmFjY2VzcyIsInN1YiI6ImRpZDpwbGM6ZXRkY2I0N3Y1NG13djJ3ZHVmaGk0dHU2IiwiaWF0IjoxNzA2ODA2ODk4LCJleHAiOjE3MDY4MTQwOTgsImF1ZCI6ImRpZDp3ZWI6ZW5va2kudXMtZWFzdC5ob3N0LmJza3kubmV0d29yayJ9.HddJlIkmxC5kkv8-ejf_oRSG6Ii8Yam3ibaksORLv6RAkF8z_qL4_k_bp4NWmyA0dnXvIvIlv9l0_ISueS7c5g", refreshToken: "eyJhbGciOiJFUzI1NksifQ.eyJzY29wZSI6ImNvbS5hdHByb3RvLnJlZnJlc2giLCJzdWIiOiJkaWQ6cGxjOmV0ZGNiNDd2NTRtd3Yyd2R1ZmhpNHR1NiIsImF1ZCI6ImRpZDp3ZWI6YnNreS5zb2NpYWwiLCJqdGkiOiIxRXNKRUNpL3pTOXMyQ1RnR29MbDNCYzBxL3lUdmN3Y0lEbURpcTFiUlU4IiwiaWF0IjoxNzA2ODA2ODk4LCJleHAiOjE3MTQ1ODI4OTh9.i9vDtPvMN2TKeQYF47YbvR8_wRlb6xIUDqMb8jlaZJ1W1SLzgQ-7cf6JYgFXsQrkmoyFLKsHVxGzXGniD2Todg", uris: ["at://did:plc:n3kx3cx5cwofnfcs6vu7cg5s/app.bsky.feed.post/3kkdaxz2jod2j"])

        let getPostsJSONDataURL = Bundle.module.url(forResource: "GetPosts", withExtension: "json")
        let getPostsJSONData = try! Data(contentsOf: getPostsJSONDataURL!)

        let posts = try JSONDecoder().decode(BlueskyFeedGetPostsResponseBody.self, from: getPostsJSONData)

        print("Foobar")
    }
}
