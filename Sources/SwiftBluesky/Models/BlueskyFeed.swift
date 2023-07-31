//
//  BlueskyFeed.swift
//  
//
//  Created by Christopher Head on 7/29/23.
//

import Foundation

public struct BlueskyFeedViewerState: Decodable {
    public let repost: String?
    public let like: String?
}

public struct BlueskyFeedPostView: Decodable {
    private enum CodingKeys: CodingKey {
        case uri
        case cid
        case author
//        case record
        case embed
        case replyCount
        case likeCount
        case indexedAt
        case viewer
        case labels
    }
    
    public let uri: String
    public let cid: String
    public let author: BlueskyActorProfileViewBasic
//    public let record: BlueskyRecord
    public let embed: BlueskyEmbedType?
    public let replyCount: Int
    public let likeCount: Int
    public let indexedAt: Date
    public let viewer: BlueskyFeedViewerState
    public let labels: [String]

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.uri = try container.decode(String.self, forKey: .uri)
        self.cid = try container.decode(String.self, forKey: .cid)
        self.author = try container.decode(BlueskyActorProfileViewBasic.self, forKey: .author)
//        self.record = try container.decode(BlueskyRecord.self, forKey: .record)
        self.embed = try container.decodeIfPresent(BlueskyEmbedType.self, forKey: .embed)
        self.replyCount = try container.decode(Int.self, forKey: .replyCount)
        self.likeCount = try container.decode(Int.self, forKey: .likeCount)

        let indexedAtString = try container.decode(String.self, forKey: .indexedAt)

        let dateFormatter = DateFormatter()

        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"

        if let indexedAtDate = dateFormatter.date(from: indexedAtString) {
            self.indexedAt = indexedAtDate
        } else {
            throw DecodingError.dataCorrupted(.init(codingPath: decoder.codingPath, debugDescription: "Invalid date format."))
        }

        self.viewer = try container.decode(BlueskyFeedViewerState.self, forKey: .viewer)
        self.labels = try container.decode([String].self, forKey: .labels)
    }
}

public struct BlueskyFeedReplyRef: Decodable {
    public let root: BlueskyFeedPostView
    public let parent: BlueskyFeedPostView
}

public struct BlueskyFeedReasonRepost: Decodable {
    private enum CodingKeys: CodingKey {
        case by
        case indexedAt
    }
    
    public let by: BlueskyActorProfileViewBasic
    public let indexedAt: Date
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.by = try container.decode(BlueskyActorProfileViewBasic.self, forKey: .by)
        
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

public struct BlueskyFeedFeedViewPost: Decodable {
    public let post: BlueskyFeedPostView
    public let reply: BlueskyFeedReplyRef?
    public let reason: BlueskyFeedReasonRepost?
}

