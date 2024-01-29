//
//  BlueskyEmbedRecord.swift
//
//
//  Created by Christopher Head on 1/24/24.
//

import Foundation
import SwiftATProto

public struct BlueskyEmbedRecordViewBlocked: Decodable {
    private enum CodingKeys: CodingKey {
        case uri
        case author
    }

    public let uri: String
    public let blocked: Bool = true
    public let author: BlueskyFeedBlockedAuthor

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.uri = try container.decode(String.self, forKey: .uri)
        self.author = try container.decode(BlueskyFeedBlockedAuthor.self, forKey: .author)
    }
}

public struct BlueskyEmbedRecordViewNotFound: Decodable {
    private enum CodingKeys: CodingKey {
        case uri
    }

    public let uri: String
    public let notFound: Bool = true

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.uri = try container.decode(String.self, forKey: .uri)
    }
}

public enum BlueskyEmbedRecordViewRecordType: Decodable {
    private enum FieldType: String, Decodable {
        case blueskyEmbedRecordViewRecord = "app.bsky.embed.record#viewRecord"
        case blueskyEmbedRecordViewNotFound = "app.bsky.embed.record#viewNotFound"
        case blueskyEmbedRecordViewBlocked = "app.bsky.embed.record#viewBlocked"
        case blueskyFeedGeneratorView = "app.bsky.feed.defs#generatorView"
        case blueskyGraphListView = "app.bsky.graph.defs#listView"
    }

    private enum CodingKeys: String, CodingKey {
        case type = "$type"
    }

    case blueskyEmbedRecordViewRecord(BlueskyEmbedRecordViewRecord)
    case blueskyEmbedRecordViewNotFound(BlueskyEmbedRecordViewNotFound)
    case blueskyEmbedRecordViewBlocked(BlueskyEmbedRecordViewBlocked)
    case blueskyFeedGeneratorView(BlueskyFeedGeneratorView)
    case blueskyGraphListView(BlueskyGraphListView)

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let fieldType = try container.decode(FieldType.self, forKey: .type)

        let singleValueContainer = try decoder.singleValueContainer()

        switch fieldType {
        case .blueskyEmbedRecordViewRecord:
            try self = .blueskyEmbedRecordViewRecord(singleValueContainer.decode(BlueskyEmbedRecordViewRecord.self))

        case .blueskyEmbedRecordViewNotFound:
            try self = .blueskyEmbedRecordViewNotFound(singleValueContainer.decode(BlueskyEmbedRecordViewNotFound.self))

        case .blueskyEmbedRecordViewBlocked:
            try self = .blueskyEmbedRecordViewBlocked(singleValueContainer.decode(BlueskyEmbedRecordViewBlocked.self))

        case .blueskyFeedGeneratorView:
            try self = .blueskyFeedGeneratorView(singleValueContainer.decode(BlueskyFeedGeneratorView.self))

        case .blueskyGraphListView:
            try self = .blueskyGraphListView(singleValueContainer.decode(BlueskyGraphListView.self))
        }
    }
}

public struct BlueskyEmbedRecordView: Decodable {
    public let record: BlueskyEmbedRecordViewRecordType
}

public enum BlueskyEmbedRecordViewRecordEmbedType: Decodable {
    private enum FieldType: String, Decodable {
        case blueskyEmbedImagesView = "app.bsky.embed.images#view"
        case blueskyEmbedExternalView = "app.bsky.embed.external#view"
        case blueskyEmbedRecordView = "app.bsky.embed.record#view"
        case blueskyEmbedRecordWithMediaView = "app.bsky.embed.recordWithMedia#view"
    }

    private enum CodingKeys: String, CodingKey {
        case type = "$type"
    }

    case blueskyEmbedImagesView(BlueskyEmbedImagesView)
    case blueskyEmbedExternalView(BlueskyEmbedExternalView)
    case blueskyEmbedRecordView(BlueskyEmbedRecordView)
    case blueskyEmbedRecordWithMediaView(BlueskyEmbedRecordWithMediaView)

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let fieldType = try container.decode(FieldType.self, forKey: .type)

        let singleValueContainer = try decoder.singleValueContainer()

        switch fieldType {
        case .blueskyEmbedImagesView:
            try self = .blueskyEmbedImagesView(singleValueContainer.decode(BlueskyEmbedImagesView.self))

        case .blueskyEmbedExternalView:
            try self = .blueskyEmbedExternalView(singleValueContainer.decode(BlueskyEmbedExternalView.self))

        case .blueskyEmbedRecordView:
            try self = .blueskyEmbedRecordView(singleValueContainer.decode(BlueskyEmbedRecordView.self))

        case .blueskyEmbedRecordWithMediaView:
            try self = .blueskyEmbedRecordWithMediaView(singleValueContainer.decode(BlueskyEmbedRecordWithMediaView.self))
        }
    }
}

public struct BlueskyEmbedRecordViewRecord: Decodable {
    private enum CodingKeys: CodingKey {
        case uri
        case cid
        case author
        case labels
        case embeds
        case indexedAt
    }

    public let uri: String
    public let cid: String
    public let author: BlueskyActorProfileViewBasic
    //    "value": { "type": "unknown" },
    public let labels: [ATProtoLabel]?
    public let embeds: [BlueskyEmbedRecordViewRecordEmbedType]?
    public let indexedAt: Date

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.uri = try container.decode(String.self, forKey: .uri)
        self.cid = try container.decode(String.self, forKey: .cid)
        self.author = try container.decode(BlueskyActorProfileViewBasic.self, forKey: .author)
        self.labels = try container.decodeIfPresent([ATProtoLabel].self, forKey: .labels)
        self.embeds = try container.decodeIfPresent([BlueskyEmbedRecordViewRecordEmbedType].self, forKey: .embeds)

        let indexedAtString = try container.decode(String.self, forKey: .indexedAt)
        let dateFormatter = DateFormatter()

        let dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        dateFormatter.dateFormat = dateFormat

        if let indexedAtDate = dateFormatter.date(from: indexedAtString) {
            self.indexedAt = indexedAtDate
        } else {
            throw DecodingError.dataCorrupted(.init(codingPath: decoder.codingPath, debugDescription: "\(dateFormat) is an invalid date format for '\(indexedAtString).'"))
        }
    }
}

public struct BlueskyEmbedRecord: Decodable {
    public let record: ATProtoRepoStrongRef
}
