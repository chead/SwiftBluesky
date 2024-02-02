//
//  BlueskyEmbed.swift
//
//
//  Created by Christopher Head on 7/29/23.
//

import Foundation

public indirect enum BlueskyEmbedType: Decodable {
    private enum FieldType: String, Decodable {
        case blueskyEmbedImages = "app.bsky.embed.images"
        case blueskyEmbedExternal = "app.bsky.embed.external"
        case blueskyEmbedRecord = "app.bsky.embed.record"
        case blueskyEmbedRecordWithMedia = "app.bsky.embed.recordWithMedia"
    }

    private enum CodingKeys: String, CodingKey {
        case type = "$type"
    }

    case blueskyEmbedImages(BlueskyEmbedImages)
    case blueskyEmbedExternal(BlueskyEmbedExternal)
    case blueskyEmbedRecord(BlueskyEmbedRecord)
    case blueskyEmbedRecordWithMedia(BlueskyEmbedRecordWithMedia)

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let fieldType = try container.decode(FieldType.self, forKey: .type)

        let singleValueContainer = try decoder.singleValueContainer()

        switch fieldType {
        case .blueskyEmbedImages:
            try self = .blueskyEmbedImages(singleValueContainer.decode(BlueskyEmbedImages.self))

        case .blueskyEmbedExternal:
            try self = .blueskyEmbedExternal(singleValueContainer.decode(BlueskyEmbedExternal.self))

        case .blueskyEmbedRecord:
            try self = .blueskyEmbedRecord(singleValueContainer.decode(BlueskyEmbedRecord.self))

        case .blueskyEmbedRecordWithMedia:
            try self = .blueskyEmbedRecordWithMedia(singleValueContainer.decode(BlueskyEmbedRecordWithMedia.self))
        }
    }
}
