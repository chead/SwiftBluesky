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
        case blueskyEmbedImagesView = "app.bsky.embed.images#view"
        case blueskyEmbedExternalView = "app.bsky.embed.external#view"
        case blueskyEmbedRecord = "app.bsky.embed.record"
        case blueskyEmbedRecordView = "app.bsky.embed.record#view"
        case blueskyEmbedRecordWithMediaView = "app.bsky.embed.recordWithMedia#view"
    }
    
    private enum CodingKeys: String, CodingKey {
        case type = "$type"
    }

    case blueskyEmbedImages(BlueskyEmbedImages)
    case blueskyEmbedImagesView(BlueskyEmbedImagesView)
    case blueskyEmbedExternalView(BlueskyEmbedExternalView)
    case blueskyEmbedRecord(BlueskyEmbedRecord)
    case blueskyEmbedRecordView(BlueskyEmbedRecordView)
    case blueskyEmbedRecordWithMediaView(BlueskyEmbedRecordWithMediaView)
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let fieldType = try container.decode(FieldType.self, forKey: .type)
        
        let singleValueContainer = try decoder.singleValueContainer()
        
        switch fieldType {
        case .blueskyEmbedImages:
            try self = .blueskyEmbedImages(singleValueContainer.decode(BlueskyEmbedImages.self))

        case .blueskyEmbedImagesView:
            try self = .blueskyEmbedImagesView(singleValueContainer.decode(BlueskyEmbedImagesView.self))
        
        case .blueskyEmbedExternalView:
            try self = .blueskyEmbedExternalView(singleValueContainer.decode(BlueskyEmbedExternalView.self))

        case .blueskyEmbedRecord:
            try self = .blueskyEmbedRecord(singleValueContainer.decode(BlueskyEmbedRecord.self))

        case .blueskyEmbedRecordView:
            try self = .blueskyEmbedRecordView(singleValueContainer.decode(BlueskyEmbedRecordView.self))

        case .blueskyEmbedRecordWithMediaView:
            try self = .blueskyEmbedRecordWithMediaView(singleValueContainer.decode(BlueskyEmbedRecordWithMediaView.self))
        }
    }
}
