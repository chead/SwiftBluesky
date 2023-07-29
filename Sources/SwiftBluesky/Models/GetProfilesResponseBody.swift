//
//  GetProfilesResponseBody.swift
//  
//
//  Created by Christopher Head on 7/28/23.
//

import Foundation

public struct BlueskyViewer: Decodable {
    let muted: Bool
    let blockedBy: Bool
}

public struct BlueskyProfile: Decodable {
    private enum CodingKeys: CodingKey {
        case did
        case handle
        case displayName
        case description
        case avatar
        case banner
        case followsCount
        case followersCount
        case postsCount
        case indexedAt
        case viewer
        case labels
    }

    let did: String
    let handle: String
    let displayName: String
    let description: String
    let avatar: String
    let banner: String
    let followsCount: Int
    let followersCount: Int
    let postsCount: Int
    let indexedAt: Date
    let viewer: BlueskyViewer
    let labels: [String]

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.did = try container.decode(String.self, forKey: .did)
        self.handle = try container.decode(String.self, forKey: .handle)
        self.displayName = try container.decode(String.self, forKey: .displayName)
        self.description = try container.decode(String.self, forKey: .description)
        self.avatar = try container.decode(String.self, forKey: .avatar)
        self.banner = try container.decode(String.self, forKey: .banner)
        self.followsCount = try container.decode(Int.self, forKey: .followsCount)
        self.followersCount = try container.decode(Int.self, forKey: .followersCount)
        self.postsCount = try container.decode(Int.self, forKey: .postsCount)
        
        let indexedAtString = try container.decode(String.self, forKey: .indexedAt)
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        
        if let indexedAtDate = dateFormatter.date(from: indexedAtString) {
            self.indexedAt = indexedAtDate
        } else {
            throw DecodingError.dataCorrupted(.init(codingPath: decoder.codingPath, debugDescription: "Invalid date format."))
        }

        self.viewer = try container.decode(BlueskyViewer.self, forKey: .viewer)
        self.labels = try container.decode([String].self, forKey: .labels)
    }
}

public struct GetProfilesResponseBody: Decodable {
    let profiles: [BlueskyProfile]
}
