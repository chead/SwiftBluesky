//
//  BlueskyEmbedRecordWithMedia.swift
//
//
//  Created by Christopher Head on 1/24/24.
//

import Foundation

public enum BlueskyEmbedRecordWithMediaViewMediaType: Decodable {
    private enum FieldType: String, Decodable {
        case blueskyEmbedImages = "app.bsky.embed.images"
        case blueskyEmbedImagesView = "app.bsky.embed.images#view"
        case blueskyEmbedExternal = "app.bsky.embed.external"
    }

    private enum CodingKeys: String, CodingKey {
        case type = "$type"
    }

    case blueskyEmbedImages(BlueskyEmbedImages)
    case blueskyEmbedImagesView(BlueskyEmbedImagesView)
    case blueskyEmbedExternal(BlueskyEmbedExternal)

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let fieldType = try container.decode(FieldType.self, forKey: .type)

        let singleValueContainer = try decoder.singleValueContainer()

        switch fieldType {
        case .blueskyEmbedImages:
            try self = .blueskyEmbedImages(singleValueContainer.decode(BlueskyEmbedImages.self))

        case .blueskyEmbedImagesView:
            try self = .blueskyEmbedImagesView(singleValueContainer.decode(BlueskyEmbedImagesView.self))

        case .blueskyEmbedExternal:
            try self = .blueskyEmbedExternal(singleValueContainer.decode(BlueskyEmbedExternal.self))
        }
    }
}

public struct BlueskyEmbedRecordWithMediaView: Decodable {
    public let record: BlueskyEmbedRecordView
    public let media: BlueskyEmbedRecordWithMediaViewMediaType
}

public enum BlueskyEmbedRecordWithMediaType: Decodable {
    private enum FieldType: String, Decodable {
        case blueskyEmbedImages = "app.bsky.embed.images"
        case blueskyEmbedExternal = "app.bsky.embed.external"
    }

    private enum CodingKeys: String, CodingKey {
        case type = "$type"
    }

    case blueskyEmbedImages(BlueskyEmbedImages)
    case blueskyEmbedExternal(BlueskyEmbedExternal)

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let fieldType = try container.decode(FieldType.self, forKey: .type)

        let singleValueContainer = try decoder.singleValueContainer()

        switch fieldType {
        case .blueskyEmbedImages:
            try self = .blueskyEmbedImages(singleValueContainer.decode(BlueskyEmbedImages.self))

        case .blueskyEmbedExternal:
            try self = .blueskyEmbedExternal(singleValueContainer.decode(BlueskyEmbedExternal.self))
        }
    }
}

public struct BlueskyEmbedRecordWithMedia: Decodable {
    public let record: BlueskyEmbedRecord
    public let media: BlueskyEmbedRecordWithMediaType
}
