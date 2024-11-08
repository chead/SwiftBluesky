//
//  BlueskyActor.swift
//  
//
//  Created by Christopher Head on 7/29/23.
//

import Foundation
import SwiftATProto

fileprivate let maxActorProfileViewDisplayNameLength = 64
fileprivate let maxActorProfileViewDescriptionLength = 256

public struct BlueskyActorViewerState: Decodable {
    public let muted: Bool
    public let blockedBy: Bool
}

public struct BlueskyActorProfile: Codable {
    private enum CodingKeys: String, CodingKey {
        case type = "$type"
        case displayName
        case description
        case avatar
        case banner
        case labels
        case joinedViaStarterPack
        case pinnedPost
        case followersCount
        case createdAt
    }

    public let displayName: String?
    public let description: String?
    public let avatar: ATProtoBlob?
    public let banner: ATProtoBlob?
    public let labels: ATProtoSelfLabels?
    public let joinedViaStarterPack: ATProtoRepoStrongRef?
    public let pinnedPost: ATProtoRepoStrongRef?
    public let createdAt: Date?

    public init(displayName: String?, description: String?, avatar: ATProtoBlob?, banner: ATProtoBlob?, labels: ATProtoSelfLabels?, joinedViaStarterPack: ATProtoRepoStrongRef?, pinnedPost: ATProtoRepoStrongRef?, createdAt: Date?) {
        self.displayName = displayName
        self.description = description
        self.avatar = avatar
        self.banner = banner
        self.labels = labels
        self.joinedViaStarterPack = joinedViaStarterPack
        self.pinnedPost = pinnedPost
        self.createdAt = createdAt
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.displayName = try container.decodeIfPresent(String.self, forKey: .displayName)
        self.description = try container.decodeIfPresent(String.self, forKey: .description)
        self.avatar = try container.decodeIfPresent(ATProtoBlob.self, forKey: .avatar)
        self.banner = try container.decodeIfPresent(ATProtoBlob.self, forKey: .banner)
        self.labels = try container.decodeIfPresent(ATProtoSelfLabels.self, forKey: .labels)
        self.joinedViaStarterPack = try container.decodeIfPresent(ATProtoRepoStrongRef.self, forKey: .joinedViaStarterPack)
        self.pinnedPost = try container.decodeIfPresent(ATProtoRepoStrongRef.self, forKey: .pinnedPost)

        if let createdAtString = try container.decodeIfPresent(String.self, forKey: .createdAt) {
            let dateFormatter = ISO8601DateFormatter()

            self.createdAt = dateFormatter.date(from: createdAtString)
        } else {
            self.createdAt = nil
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode("app.bsky.actor.profile", forKey: .type)
        try container.encodeIfPresent(displayName, forKey: .displayName)
        try container.encodeIfPresent(description, forKey: .description)
        try container.encodeIfPresent(avatar, forKey: .avatar)
        try container.encodeIfPresent(banner, forKey: .banner)
        try container.encodeIfPresent(labels, forKey: .labels)
        try container.encodeIfPresent(joinedViaStarterPack, forKey: .joinedViaStarterPack)
        try container.encodeIfPresent(pinnedPost, forKey: .pinnedPost)

        if let createdAt = createdAt {
            let dateFormatter = ISO8601DateFormatter()
            
            dateFormatter.formatOptions = [.withInternetDateTime]
            
            try container.encode(dateFormatter.string(from: createdAt), forKey: .createdAt)
        }
    }
}

public struct BlueskyActorProfileViewBasic: Decodable {
    private enum CodingKeys: CodingKey {
        case did
        case handle
        case displayName
        case avatar
        case viewer
        case labels
    }

    public let did: String
    public let handle: String
    public let displayName: String?
    public let avatar: String?
    public let viewer: BlueskyActorViewerState?
    public let labels: [ATProtoLabel]?

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.did = try container.decode(String.self, forKey: .did)
        self.handle = try container.decode(String.self, forKey: .handle)
        

        let displayName = try container.decodeIfPresent(String.self, forKey: .displayName)

        if let displayName = displayName {
            guard displayName.count <= maxActorProfileViewDisplayNameLength else {
                throw DecodingError.dataCorrupted(.init(codingPath: decoder.codingPath, debugDescription: "Display name longer than maximum character count \(maxActorProfileViewDisplayNameLength)."))
            }
        }

        self.displayName = displayName

        self.avatar = try container.decodeIfPresent(String.self, forKey: .avatar)
        self.viewer = try container.decodeIfPresent(BlueskyActorViewerState.self, forKey: .viewer)
        self.labels = try container.decodeIfPresent([ATProtoLabel].self, forKey: .labels)
    }
}

public struct BlueskyActorProfileView: Decodable {
    private enum CodingKeys: CodingKey {
        case did
        case handle
        case displayName
        case description
        case avatar
        case viewer
        case labels
    }

    public let did: String
    public let handle: String
    public let displayName: String?
    public let description: String?
    public let avatar: String?
    public let viewer: BlueskyActorViewerState?
    public let labels: [ATProtoLabel]?

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.did = try container.decode(String.self, forKey: .did)
        self.handle = try container.decode(String.self, forKey: .handle)

        let displayName = try container.decodeIfPresent(String.self, forKey: .displayName)

        if let displayName = displayName {
            guard displayName.count <= maxActorProfileViewDisplayNameLength else {
                throw DecodingError.dataCorrupted(.init(codingPath: decoder.codingPath, debugDescription: "Display name longer than maximum character count \(maxActorProfileViewDisplayNameLength)."))
            }
        }

        self.displayName = displayName

        let description = try container.decodeIfPresent(String.self, forKey: .description)

        if let description = description {
            guard description.count <= maxActorProfileViewDescriptionLength else {
                throw DecodingError.dataCorrupted(.init(codingPath: decoder.codingPath, debugDescription: "Description longer than maximum character count \(maxActorProfileViewDescriptionLength)."))
            }
        }

        self.description = description

        self.avatar = try container.decodeIfPresent(String.self, forKey: .avatar)
        self.viewer = try container.decodeIfPresent(BlueskyActorViewerState.self, forKey: .viewer)
        self.labels = try container.decodeIfPresent([ATProtoLabel].self, forKey: .labels)
    }
}

public struct BlueskyActorProfileViewDetailed: Decodable {
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

    public let did: String
    public let handle: String
    public let displayName: String?
    public let description: String?
    public let avatar: String?
    public let banner: String?
    public let followsCount: Int?
    public let followersCount: Int?
    public let postsCount: Int?
    public let indexedAt: Date?
    public let viewer: BlueskyActorViewerState?
    public let labels: [ATProtoLabel]?

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.did = try container.decode(String.self, forKey: .did)
        self.handle = try container.decode(String.self, forKey: .handle)
        
        let displayName = try container.decodeIfPresent(String.self, forKey: .displayName)

        if let displayName = displayName {
            guard displayName.count <= maxActorProfileViewDisplayNameLength else {
                throw DecodingError.dataCorrupted(.init(codingPath: decoder.codingPath, debugDescription: "Display name longer than maximum characters (\(maxActorProfileViewDisplayNameLength))."))
            }
        }

        self.displayName = displayName

        let description = try container.decodeIfPresent(String.self, forKey: .description)

        if let description = description {
            guard description.count <= maxActorProfileViewDescriptionLength else {
                throw DecodingError.dataCorrupted(.init(codingPath: decoder.codingPath, debugDescription: "Description longer than maximum characters (\(maxActorProfileViewDescriptionLength))."))
            }
        }

        self.description = description
        
        self.avatar = try container.decodeIfPresent(String.self, forKey: .avatar)
        self.banner = try container.decodeIfPresent(String.self, forKey: .banner)
        self.followsCount = try container.decodeIfPresent(Int.self, forKey: .followsCount)
        self.followersCount = try container.decodeIfPresent(Int.self, forKey: .followersCount)
        self.postsCount = try container.decodeIfPresent(Int.self, forKey: .postsCount)
        
        if let indexedAtString = try container.decodeIfPresent(String.self, forKey: .indexedAt) {
            let dateFormatter = DateFormatter()
            
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
            
            self.indexedAt = dateFormatter.date(from: indexedAtString)
        } else {
            self.indexedAt = nil
        }

        self.viewer = try container.decodeIfPresent(BlueskyActorViewerState.self, forKey: .viewer)
        self.labels = try container.decodeIfPresent([ATProtoLabel].self, forKey: .labels)
    }
}
