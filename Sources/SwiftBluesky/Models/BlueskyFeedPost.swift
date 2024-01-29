//
//  BlueskyFeedPost.swift
//  
//
//  Created by Christopher Head on 7/30/23.
//

import Foundation
import SwiftATProto

public struct BlueskyFeedPostRepyRef: Decodable {
    public let root: ATProtoRepoStrongRef
    public let parent: ATProtoRepoStrongRef
}

public struct BlueskyFeedPost: Decodable {
    private enum CodingKeys: CodingKey {
        case text
        case faces
        case reply
        case embed
        case createdAt
    }

    public let text: String
    public let facets: [BlueskyRichtextFacet]?
    public let reply: BlueskyFeedPostRepyRef?
    public let embed: BlueskyEmbedType?
    public let createdAt: Date
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.text = try container.decode(String.self, forKey: .text)
        self.facets = try container.decodeIfPresent([BlueskyRichtextFacet].self, forKey: .faces)
        self.reply = try container.decodeIfPresent(BlueskyFeedPostRepyRef.self, forKey: .reply)
        self.embed = try container.decodeIfPresent(BlueskyEmbedType.self, forKey: .embed)
        
        let createdAtString = try container.decode(String.self, forKey: .createdAt)
        
        let dateFormatterLong = DateFormatter()

        let dateFormatLong = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"

        dateFormatterLong.dateFormat = dateFormatLong

        let dateFormatterMedium = DateFormatter()

        let dateFormatMedium = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"

        dateFormatterMedium.dateFormat = dateFormatMedium

        let dateFormatterShort = DateFormatter()

        let dateFormatShort = "yyyy-MM-dd'T'HH:mm:ss'Z'"

        dateFormatterShort.dateFormat = dateFormatShort

        if let createdAtDateLong = dateFormatterLong.date(from: createdAtString) {
            self.createdAt = createdAtDateLong
        } else if let createdAtDateMedium = dateFormatterMedium.date(from: createdAtString) {
            self.createdAt = createdAtDateMedium
        } else if let createdAtDateShort = dateFormatterShort.date(from: createdAtString) {
            self.createdAt = createdAtDateShort
        } else {
            throw DecodingError.dataCorrupted(.init(codingPath: decoder.codingPath, debugDescription: "Invalid date format for '\(createdAtString).'"))
        }
    }
}
