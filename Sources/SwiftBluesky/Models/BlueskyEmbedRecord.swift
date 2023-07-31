//
//  BlueskyEmbedRecord.swift
//  
//
//  Created by Christopher Head on 7/30/23.
//

import Foundation

public enum BlueskyEmbedRecordViewRecordValueType: Decodable {
    private enum FieldType: String, Decodable {
        case blueskyFeedPost = "app.bsky.feed.post"
    }
    
    private enum CodingKeys: String, CodingKey {
        case type = "$type"
    }

    case blueskyFeedPost(BlueskyFeedPost)
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let fieldType = try container.decode(FieldType.self, forKey: .type)
        
        let singleValueContainer = try decoder.singleValueContainer()
        
        switch fieldType {
        case .blueskyFeedPost:
            try self = .blueskyFeedPost(singleValueContainer.decode(BlueskyFeedPost.self))
        }
    }
}

public struct BlueskyEmbedRecordViewRecord: Decodable {
    private enum CodingKeys: CodingKey {
        case uri
        case cid
        case author
        case value
        case indexedAt
    }

    public let uri: String
    public let cid: String
    public let author: BlueskyActorProfileViewBasic
    public let value: BlueskyEmbedRecordViewRecordValueType
    public let indexedAt: Date
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.uri = try container.decode(String.self, forKey: .uri)
        self.cid = try container.decode(String.self, forKey: .cid)
        self.author = try container.decode(BlueskyActorProfileViewBasic.self, forKey: .author)
        self.value = try container.decode(BlueskyEmbedRecordViewRecordValueType.self, forKey: .value)
        
        let indexedAtString = try container.decode(String.self, forKey: .indexedAt)
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        
        if let indexedAtDate = dateFormatter.date(from: indexedAtString) {
            self.indexedAt = indexedAtDate
        } else {
            throw DecodingError.dataCorrupted(.init(codingPath: decoder.codingPath, debugDescription: "Invalid date format."))
        }
    }
}

public struct BlueskyEmbedRecordViewNotFound: Decodable {
    let uri: String
}

public struct BlueskyEmbedRecordViewBlocked: Decodable {
    let uri: String
}

public enum BlueskyEmbedRecordViewRecordType: Decodable {
    private enum FieldType: String, Decodable {
        case viewRecord = "app.bsky.embed.record#viewRecord"
        case viewNotFound = "app.bsky.embed.record#viewNotFound"
        case viewBlocked = "app.bsky.embed.record#viewBlocked"
    }
    
    private enum CodingKeys: String, CodingKey {
        case type = "$type"
    }

    case viewRecord(BlueskyEmbedRecordViewRecord)
    case viewNotFound(BlueskyEmbedRecordViewNotFound)
    case viewBlocked(BlueskyEmbedRecordViewBlocked)

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let fieldType = try container.decode(FieldType.self, forKey: .type)
        
        let singleValueContainer = try decoder.singleValueContainer()
        
        switch fieldType {
        case .viewRecord:
            try self = .viewRecord(singleValueContainer.decode(BlueskyEmbedRecordViewRecord.self))
        
        case .viewNotFound:
            try self = .viewNotFound(singleValueContainer.decode(BlueskyEmbedRecordViewNotFound.self))

        case .viewBlocked:
            try self = .viewBlocked(singleValueContainer.decode(BlueskyEmbedRecordViewBlocked.self))
        }
    }
}

public struct BlueskyEmbedRecordView: Decodable {
    public let record: BlueskyEmbedRecordViewRecordType
}

public struct BlueskyEmbedRecord: Decodable {
    public let record: ATProtoRepoStrongRef
}
