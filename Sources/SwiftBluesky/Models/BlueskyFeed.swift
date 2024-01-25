//
//  BlueskyFeed.swift
//
//
//  Created by Christopher Head on 1/23/24.
//

import Foundation
import SwiftATProto

fileprivate let maxFeedGeneratorViewDisplayNameLength = 3000

public struct BlueskyFeedThreadgateView: Decodable {
    public let uri: String?
    public let cid: String?
    public let record: BlueskyFeedPost
    public let lists: [BlueskyGraphListViewBasic]?
}

public struct BlueskyFeedSkeletonReasonRepost: Decodable {
    public let repost: String
}

public enum BlueskyFeedSkeletonFeedPostReasonType: Decodable {
    case blueskyFeedSkeletonReasonRepost(BlueskyFeedSkeletonReasonRepost)
}

public struct BlueskyFeedSkeletonFeedPost: Decodable {
    public let post: String
    public let reason: BlueskyFeedSkeletonFeedPostReasonType?
}

public struct BlueskyFeedGeneratorViewerState: Decodable {
    public let like: String?
}

public struct BlueskyFeedGeneratorView: Decodable {
    private enum CodingKeys: CodingKey {
        case uri
        case cid
        case did
        case creator
        case displayName
        case avatar
        case likeCount
        case viewer
        case indexedAt
    }

    public let uri: String
    public let cid: String
    public let did: String
    public let creator: BlueskyActorProfileView
    public let displayName: String
    public let avatar: String?
    public let likeCount: Int?
    public let viewer: BlueskyFeedGeneratorViewerState?
    public let indexedAt: Date

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.uri = try container.decode(String.self, forKey: .uri)
        self.cid = try container.decode(String.self, forKey: .cid)
        self.did = try container.decode(String.self, forKey: .did)
        self.creator = try container.decode(BlueskyActorProfileView.self, forKey: .creator)

        let displayName = try container.decode(String.self, forKey: .displayName)

        guard displayName.count <= maxFeedGeneratorViewDisplayNameLength else {
            throw DecodingError.dataCorrupted(.init(codingPath: decoder.codingPath, debugDescription: "Display name longer than maximum character count \(maxFeedGeneratorViewDisplayNameLength)."))
        }

        self.displayName = displayName

        self.avatar = try container.decodeIfPresent(String.self, forKey: .avatar)
        self.likeCount = try container.decodeIfPresent(Int.self, forKey: .likeCount)
        self.viewer = try container.decodeIfPresent(BlueskyFeedGeneratorViewerState.self, forKey: .viewer)

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

public struct BlueskyFeedViewerState: Decodable {
    public let repost: String?
    public let like: String?
    public let replyDisabled: Bool?
}

public struct BlueskyFeedBlockedAuthor: Decodable {
    public let did: String
    public let viewerState: BlueskyFeedViewerState?
}

public struct BlueskyFeedBlockedPost: Decodable {
    private enum CodingKeys: CodingKey {
        case uri
        case author
    }

    public let uri: String
    public let blocked: Bool
    public let author: BlueskyFeedBlockedAuthor

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.uri = try container.decode(String.self, forKey: .uri)
        self.blocked = true
        self.author = try container.decode(BlueskyFeedBlockedAuthor.self, forKey: .author)
    }
}

public struct BlueskyFeedNotFoundPost: Decodable {
    private enum CodingKeys: CodingKey {
        case uri
    }

    public let uri: String
    public let notFound: Bool

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.uri = try container.decode(String.self, forKey: .uri)
        self.notFound = true
    }
}

public enum BlueskyFeedPostViewEmbedType: Decodable {
    private enum FieldType: String, Decodable {
        case blueskyEmbedImages = "app.bsky.embed.images"
        case blueskyEmbedImagesView = "app.bsky.embed.images#view"
        case blueskyEmbedExternal = "app.bsky.embed.external"
        case blueskyEmbedExternalView = "app.bsky.embed.external#view"
        case blueskyEmbedRecord = "app.bsky.embed.record"
        case blueskyEmbedRecordView = "app.bsky.embed.record#view"
        case blueskyEmbedRecordWithMedia = "app.bsky.embed.recordWithMedia"
        case blueskyEmbedRecordWithMediaView = "app.bsky.embed.recordWithMedia#view"
    }

    private enum CodingKeys: String, CodingKey {
        case type = "$type"
    }

    case blueskyEmbedImages(BlueskyEmbedImages)
    case blueskyEmbedImagesView(BlueskyEmbedImagesView)
    case blueskyEmbedExternal(BlueskyEmbedExternal)
    case blueskyEmbedExternalView(BlueskyEmbedExternalView)
    case blueskyEmbedRecord(BlueskyEmbedRecord)
    case blueskyEmbedRecordView(BlueskyEmbedRecordView)
    case blueskyEmbedRecordWithMedia(BlueskyEmbedRecordWithMedia)
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

        case .blueskyEmbedExternal:
            try self = .blueskyEmbedExternal(singleValueContainer.decode(BlueskyEmbedExternal.self))

        case .blueskyEmbedExternalView:
            try self = .blueskyEmbedExternalView(singleValueContainer.decode(BlueskyEmbedExternalView.self))

        case .blueskyEmbedRecord:
            try self = .blueskyEmbedRecord(singleValueContainer.decode(BlueskyEmbedRecord.self))

        case .blueskyEmbedRecordView:
            try self = .blueskyEmbedRecordView(singleValueContainer.decode(BlueskyEmbedRecordView.self))

        case .blueskyEmbedRecordWithMedia:
            try self = .blueskyEmbedRecordWithMedia(singleValueContainer.decode(BlueskyEmbedRecordWithMedia.self))

        case .blueskyEmbedRecordWithMediaView:
            try self = .blueskyEmbedRecordWithMediaView(singleValueContainer.decode(BlueskyEmbedRecordWithMediaView.self))
        }
    }

}

public struct BlueskyFeedPostView: Decodable {
    private enum CodingKeys: CodingKey {
        case uri
        case cid
        case author
        case embed
        case replyCount
        case repostCount
        case likeCount
        case indexedAt
        case viewer
        case labels
        case threadgate
    }

    public let uri: String
    public let cid: String
    public let author: BlueskyActorProfileViewBasic
//    "record": { "type": "unknown" },
    public let embed: BlueskyFeedPostViewEmbedType?
    public let replyCount: Int?
    public let repostCount: Int?
    public let likeCount: Int?
    public let indexedAt: Date
    public let viewer: BlueskyFeedViewerState?
    public let labels: [ATProtoLabel]?
    public let threadgate: BlueskyFeedThreadgateView?

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.uri = try container.decode(String.self, forKey: .uri)
        self.cid = try container.decode(String.self, forKey: .cid)
        self.author = try container.decode(BlueskyActorProfileViewBasic.self, forKey: .author)
        self.embed = try container.decodeIfPresent(BlueskyFeedPostViewEmbedType.self, forKey: .embed)
        self.replyCount = try container.decodeIfPresent(Int.self, forKey: .replyCount)
        self.repostCount = try container.decodeIfPresent(Int.self, forKey: .repostCount)
        self.likeCount = try container.decodeIfPresent(Int.self, forKey: .likeCount)

        let indexedAtString = try container.decode(String.self, forKey: .indexedAt)
        let dateFormatter = DateFormatter()

        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"

        if let indexedAtDate = dateFormatter.date(from: indexedAtString) {
            self.indexedAt = indexedAtDate
        } else {
            throw DecodingError.dataCorrupted(.init(codingPath: decoder.codingPath, debugDescription: "Invalid date format."))
        }

        self.viewer = try container.decodeIfPresent(BlueskyFeedViewerState.self, forKey: .viewer)
        self.labels = try container.decodeIfPresent([ATProtoLabel].self, forKey: .labels)
        self.threadgate = try container.decodeIfPresent(BlueskyFeedThreadgateView.self, forKey: .threadgate)
    }
}

public indirect enum BlueskyFeedThreadViewPostPostType: Decodable {
    private enum FieldType: String, Decodable {
        case blueskyFeedThreadViewPost = "app.bsky.feed.defs#threadViewPost"
        case blueskyFeedNotFoundPost = "app.bsky.feed.defs#notFoundPost"
        case blueskyFeedBlockedPost = "app.bsky.feed.defs#blockedPost"
    }

    private enum CodingKeys: String, CodingKey {
        case type = "$type"
    }

    case blueskyFeedThreadViewPost(BlueskyFeedThreadViewPost)
    case blueskyFeedNotFoundPost(BlueskyFeedNotFoundPost)
    case blueskyFeedBlockedPost(BlueskyFeedBlockedPost)

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let fieldType = try container.decode(FieldType.self, forKey: .type)

        let singleValueContainer = try decoder.singleValueContainer()

        switch fieldType {
        case .blueskyFeedThreadViewPost:
            try self = .blueskyFeedThreadViewPost(singleValueContainer.decode(BlueskyFeedThreadViewPost.self))

        case .blueskyFeedNotFoundPost:
            try self = .blueskyFeedNotFoundPost(singleValueContainer.decode(BlueskyFeedNotFoundPost.self))

        case .blueskyFeedBlockedPost:
            try self = .blueskyFeedBlockedPost(singleValueContainer.decode(BlueskyFeedBlockedPost.self))
        }
    }
}

public struct BlueskyFeedThreadViewPost: Decodable {
    public let post: BlueskyFeedPostView
    public let parent: BlueskyFeedThreadViewPostPostType
    public let replies: [BlueskyFeedThreadViewPostPostType]
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

public enum BlueskyFeedReplyRefPostType: Decodable {
    private enum FieldType: String, Decodable {
        case blueskyFeedPostView = "app.bsky.feed.defs#postView"
        case blueskyFeedNotFoundPost = "app.bsky.feed.defs#notFoundPost"
        case blueskyFeedBlockedPost = "app.bsky.feed.defs#blockedPost"
    }

    private enum CodingKeys: String, CodingKey {
        case type = "$type"
    }

    case blueskyFeedPostView(BlueskyFeedPostView)
    case blueskyFeedNotFoundPost(BlueskyFeedNotFoundPost)
    case blueskyFeedBlockedPost(BlueskyFeedBlockedPost)

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let fieldType = try container.decode(FieldType.self, forKey: .type)

        let singleValueContainer = try decoder.singleValueContainer()

        switch fieldType {
        case .blueskyFeedPostView:
            try self = .blueskyFeedPostView(singleValueContainer.decode(BlueskyFeedPostView.self))

        case .blueskyFeedNotFoundPost:
            try self = .blueskyFeedNotFoundPost(singleValueContainer.decode(BlueskyFeedNotFoundPost.self))

        case .blueskyFeedBlockedPost:
            try self = .blueskyFeedBlockedPost(singleValueContainer.decode(BlueskyFeedBlockedPost.self))
        }
    }
}

public struct BlueskyFeedReplyRef: Decodable {
    public let root: BlueskyFeedReplyRefPostType
    public let parent: BlueskyFeedReplyRefPostType
}

public enum BlueskyFeedFeedViewPostReasonType: Decodable {
    private enum FieldType: String, Decodable {
        case blueskyFeedReasonRepost = "app.bsky.feed.defs#reasonRepost"
    }

    private enum CodingKeys: String, CodingKey {
        case type = "$type"
    }

    case blueskyFeedReasonRepost(BlueskyFeedReasonRepost)

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let fieldType = try container.decode(FieldType.self, forKey: .type)

        let singleValueContainer = try decoder.singleValueContainer()

        switch fieldType {
        case .blueskyFeedReasonRepost:
            try self = .blueskyFeedReasonRepost(singleValueContainer.decode(BlueskyFeedReasonRepost.self))
        }
    }
}

public struct BlueskyFeedFeedViewPost: Decodable {
    public let post: BlueskyFeedPostView
    public let reply: BlueskyFeedReplyRef?
    public let reason: BlueskyFeedFeedViewPostReasonType?
}
