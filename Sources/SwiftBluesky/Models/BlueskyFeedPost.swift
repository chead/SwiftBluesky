//
//  BlueskyFeedPost.swift
//  
//
//  Created by Christopher Head on 7/30/23.
//

import Foundation
import SwiftATProto

public struct BlueskyFeedPostReplyRef: Decodable {
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
    public let reply: BlueskyFeedPostReplyRef?
    public let embed: BlueskyEmbedType?
    public let createdAt: Date
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.text = try container.decode(String.self, forKey: .text)
        self.facets = try container.decodeIfPresent([BlueskyRichtextFacet].self, forKey: .faces)
        self.reply = try container.decodeIfPresent(BlueskyFeedPostReplyRef.self, forKey: .reply)
        self.embed = try container.decodeIfPresent(BlueskyEmbedType.self, forKey: .embed)
        
        let createdAtString = try container.decode(String.self, forKey: .createdAt)
        let dateFormatter = DateFormatter()

        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"

        self.createdAt = dateFormatter.date(from: createdAtString) ?? Date.distantPast
    }
}
