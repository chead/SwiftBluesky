//
//  BlueskyPost.swift
//  
//
//  Created by Christopher Head on 7/29/23.
//

import Foundation

public struct BlueskyPost: Decodable {
    private enum CodingKeys: CodingKey {
        case uri
        case cid
        case author
        case replyCount
        case likeCount
        case indexedAt
        case viewer
        case labels
    }
    
    public let uri: String
    public let cid: String
    public let author: BlueskyAuthor
    public let replyCount: Int
    public let likeCount: Int
    public let indexedAt: Date
    public let viewer: BlueskyFeedViewerState
    public let labels: [String]

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.uri = try container.decode(String.self, forKey: .uri)
        self.cid = try container.decode(String.self, forKey: .cid)
        self.author = try container.decode(BlueskyAuthor.self, forKey: .author)
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
