//
//  BlueskyGraph.swift
//
//
//  Created by Christopher Head on 1/23/24.
//

import Foundation

fileprivate let maxGraphListViewNameLength = 64
fileprivate let maxGraphListViewDesriptionLength = 3000

public struct BlueskyGraphListViewerState: Decodable {
    public let muted: Bool?
    public let blocked: String?
}

public enum BlueskyGraphListPurpose: String, Decodable {
    case modList = "app.bsky.graph.defs#modlist"
    case curateList = "app.bsky.graph.defs#curatelist"
}

public struct BlueskyGraphListItemView: Decodable {
    public let uri: String
    public let subject: BlueskyActorProfileView
}

public struct BlueskyGraphListView: Decodable {
    private enum CodingKeys: CodingKey {
        case uri
        case cid
        case creator
        case name
        case purpose
        case description
        case descriptionFacets
        case avatar
        case viewer
        case indexedAt
    }

    public let uri: String
    public let cid: String
    public let creator: BlueskyActorProfileView
    public let name: String
    public let purpose: BlueskyGraphListPurpose
    public let description: String?
    public let descriptionFacets: [BlueskyRichtextFacet]?
    public let avatar: String?
    public let viewer: BlueskyGraphListViewerState?
    public let indexedAt: Date

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.uri = try container.decode(String.self, forKey: .uri)
        self.cid = try container.decode(String.self, forKey: .cid)
        self.creator = try container.decode(BlueskyActorProfileView.self, forKey: .creator)
        self.name = try container.decode(String.self, forKey: .name)
        self.purpose = try container.decode(BlueskyGraphListPurpose.self, forKey: .purpose)

        let description = try container.decodeIfPresent(String.self, forKey: .description)

        if let description = description {
            guard description.count <= maxGraphListViewDesriptionLength else {
                throw DecodingError.dataCorrupted(.init(codingPath: decoder.codingPath, debugDescription: "Description longer than maximum characters (\(maxGraphListViewDesriptionLength))."))
            }
        }

        self.description = description

        self.descriptionFacets = try container.decodeIfPresent([BlueskyRichtextFacet].self, forKey: .descriptionFacets)
        self.avatar = try container.decodeIfPresent(String.self, forKey: .avatar)
        self.viewer = try container.decodeIfPresent(BlueskyGraphListViewerState.self, forKey: .viewer)

        let indexedAtString = try container.decode(String.self, forKey: .indexedAt)
        let dateFormatter = DateFormatter()

        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"

        self.indexedAt = dateFormatter.date(from: indexedAtString) ?? Date.distantPast
    }
}

public struct BlueskyGraphListViewBasic: Decodable {
    private enum CodingKeys: CodingKey {
        case uri
        case cid
        case creator
        case name
        case purpose
        case avatar
        case viewer
        case indexedAt
    }

    public let uri: String
    public let cid: String
    public let creator: BlueskyActorProfileView
    public let name: String
    public let purpose: BlueskyGraphListPurpose
    public let avatar: String?
    public let viewer: BlueskyGraphListViewerState?
    public let indexedAt: Date?

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.uri = try container.decode(String.self, forKey: .uri)
        self.cid = try container.decode(String.self, forKey: .cid)
        self.creator = try container.decode(BlueskyActorProfileView.self, forKey: .creator)
        self.name = try container.decode(String.self, forKey: .name)
        self.purpose = try container.decode(BlueskyGraphListPurpose.self, forKey: .purpose)

        self.avatar = try container.decodeIfPresent(String.self, forKey: .avatar)
        self.viewer = try container.decodeIfPresent(BlueskyGraphListViewerState.self, forKey: .viewer)

        if let indexedAtString = try container.decodeIfPresent(String.self, forKey: .indexedAt) {
            let dateFormatter = DateFormatter()

            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"

            self.indexedAt = dateFormatter.date(from: indexedAtString) ?? Date.distantPast
        } else {
            self.indexedAt = nil
        }
    }
}
