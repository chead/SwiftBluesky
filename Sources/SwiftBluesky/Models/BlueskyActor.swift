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
            
            if let indexedAtDate = dateFormatter.date(from: indexedAtString) {
                self.indexedAt = indexedAtDate
            } else {
                throw DecodingError.dataCorrupted(.init(codingPath: decoder.codingPath, debugDescription: "Invalid date format."))
            }
        } else {
            self.indexedAt = nil
        }

        self.viewer = try container.decodeIfPresent(BlueskyActorViewerState.self, forKey: .viewer)
        self.labels = try container.decodeIfPresent([ATProtoLabel].self, forKey: .labels)
    }
}
