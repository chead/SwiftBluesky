import XCTest
@testable import SwiftBluesky

final class BlueskyClientTests: XCTestCase {
    @available(iOS 16.0, *)
    func testCreateSession() async throws {
        let blueskyClient = BlueskyClient(host: URL(string: "")!)
        
        let createSessionResponse = try await blueskyClient.createSession(identifier: "", password: "")

        switch createSessionResponse {
        case .success(let createSessionResponseValue):
            break

        case .failure(_):
            break
        }
    }

    @available(iOS 16.0, *)
    func testGetActor() async throws {
        let blueskyClient = BlueskyClient(host: URL(string: "")!)

        let getProfilesResponse = try await blueskyClient.getProfiles(token: "", actors: [])
        
//        switch createSessionResponse {
//        case .success(let createSessionResponseValue):
//            break
//
//        case .failure(_):
//            break
//        }
    }

    @available(iOS 16.0, *)
    func testRefreshSession() async throws {
        let blueskyClient = BlueskyClient(host: URL(string: "")!)
        
        let refreshSessionResponse = try await blueskyClient.refreshSession(token: "")

        switch refreshSessionResponse {
        case .success(let refreshSessionResponseValue):
            break

        case .failure(_):
            break
        }
    }
}
