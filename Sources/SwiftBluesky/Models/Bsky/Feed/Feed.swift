//
//  BskyFeed.swift
//  SwiftBluesky
//
//  Created by Christopher Head on 11/10/24.
//

import Foundation
import SwiftATProto
import AnyCodable

public extension Bsky {
    class Feed {
        public class PostView: Decodable {
            private enum CodingKeys: CodingKey {
                case uri
                case cid
                case author
                case record
                case embed
                case replyCount
                case repostCount
                case likeCount
                case indexedAt
                case viewer
                case labels
                case threadgate
            }

            public enum EmbedType: Decodable {
                private enum FieldType: String, Decodable {
                    case blueskyEmbedImagesView = "app.bsky.embed.images#view"
                    case blueskyEmbedExternalView = "app.bsky.embed.external#view"
                    case blueskyEmbedRecordView = "app.bsky.embed.record#view"
                    case blueskyEmbedRecordWithMediaView = "app.bsky.embed.recordWithMedia#view"
                    case blueskyEmbedVideoView = "app.bsky.embed.video#view"
                }

                private enum CodingKeys: String, CodingKey {
                    case type = "$type"
                }

                case blueskyEmbedImagesView(Embed.Images.View)
                case blueskyEmbedExternalView(Embed.External.View)
                case blueskyEmbedRecordView(Embed.Record.View)
                case blueskyEmbedRecordWithMediaView(Embed.RecordWithMedia.View)
                case blueskyEmbedVideoView(Embed.Video.View)

                public init(from decoder: Decoder) throws {
                    let container = try decoder.container(keyedBy: CodingKeys.self)
                    let fieldType = try container.decode(FieldType.self, forKey: .type)
                    let singleValueContainer = try decoder.singleValueContainer()

                    switch fieldType {
                    case .blueskyEmbedImagesView:
                        try self = .blueskyEmbedImagesView(singleValueContainer.decode(Embed.Images.View.self))

                    case .blueskyEmbedExternalView:
                        try self = .blueskyEmbedExternalView(singleValueContainer.decode(Embed.External.View.self))

                    case .blueskyEmbedRecordView:
                        try self = .blueskyEmbedRecordView(singleValueContainer.decode(Embed.Record.View.self))

                    case .blueskyEmbedRecordWithMediaView:
                        try self = .blueskyEmbedRecordWithMediaView(singleValueContainer.decode(Embed.RecordWithMedia.View.self))

                    case .blueskyEmbedVideoView:
                        try self = .blueskyEmbedVideoView(singleValueContainer.decode(Embed.Video.View.self))
                    }
                }
            }

            public let uri: String
            public let cid: String
            public let author: BskyActor.ProfileViewBasic
            public let record: AnyDecodable
            public let embed: EmbedType?
            public let replyCount: Int?
            public let repostCount: Int?
            public let likeCount: Int?
            public let indexedAt: Date
            public let viewer: ViewerState?
            public let labels: [ATProtoLabel]?
            public let threadgate: ThreadgateView?

            required public init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)

                self.uri = try container.decode(String.self, forKey: .uri)
                self.cid = try container.decode(String.self, forKey: .cid)
                self.author = try container.decode(BskyActor.ProfileViewBasic.self, forKey: .author)
                self.record = try container.decode(AnyDecodable.self, forKey: .record)
                self.embed = try container.decodeIfPresent(EmbedType.self, forKey: .embed)
                self.replyCount = try container.decodeIfPresent(Int.self, forKey: .replyCount)
                self.repostCount = try container.decodeIfPresent(Int.self, forKey: .repostCount)
                self.likeCount = try container.decodeIfPresent(Int.self, forKey: .likeCount)

                let indexedAtString = try container.decode(String.self, forKey: .indexedAt)
                let dateFormatter = DateFormatter()

                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
                dateFormatter.timeZone = TimeZone(abbreviation: "UTC")

                self.indexedAt = dateFormatter.date(from: indexedAtString) ?? Date.distantPast

                self.viewer = try container.decodeIfPresent(ViewerState.self, forKey: .viewer)
                self.labels = try container.decodeIfPresent([ATProtoLabel].self, forKey: .labels)
                self.threadgate = try container.decodeIfPresent(ThreadgateView.self, forKey: .threadgate)
            }
        }

        public class ViewerState: Decodable {
            public let repost: String?
            public let like: String?
            public let threadMuted: Bool?
            public let replyDisabled: Bool?
            public let embeddedDisabled: Bool?
            public let pinned: Bool?
        }

        public class FeedViewPost: Decodable {
            public enum ReasonType: Decodable {
                private enum FieldType: String, Decodable {
                    case reasonRepost = "app.bsky.feed.defs#reasonRepost"
                }

                private enum CodingKeys: String, CodingKey {
                    case type = "$type"
                }

                case reasonRepost(ReasonRepost)

                public init(from decoder: Decoder) throws {
                    let container = try decoder.container(keyedBy: CodingKeys.self)
                    let fieldType = try container.decode(FieldType.self, forKey: .type)
                    let singleValueContainer = try decoder.singleValueContainer()

                    switch fieldType {
                    case .reasonRepost:
                        try self = .reasonRepost(singleValueContainer.decode(ReasonRepost.self))
                    }
                }
            }

            public let post: PostView
            public let reply: ReplyRef?
            public let reason: ReasonType?
        }

        public class ReplyRef: Decodable {
            public enum PostType: Decodable {
                private enum FieldType: String, Decodable {
                    case blueskyFeedPostView = "app.bsky.feed.defs#postView"
                    case blueskyFeedNotFoundPost = "app.bsky.feed.defs#notFoundPost"
                    case blueskyFeedBlockedPost = "app.bsky.feed.defs#blockedPost"
                }

                private enum CodingKeys: String, CodingKey {
                    case type = "$type"
                }

                case blueskyFeedPostView(PostView)
                case blueskyFeedNotFoundPost(NotFoundPost)
                case blueskyFeedBlockedPost(BlockedPost)

                public init(from decoder: Decoder) throws {
                    let container = try decoder.container(keyedBy: CodingKeys.self)
                    let fieldType = try container.decode(FieldType.self, forKey: .type)
                    let singleValueContainer = try decoder.singleValueContainer()

                    switch fieldType {
                    case .blueskyFeedPostView:
                        try self = .blueskyFeedPostView(singleValueContainer.decode(PostView.self))

                    case .blueskyFeedNotFoundPost:
                        try self = .blueskyFeedNotFoundPost(singleValueContainer.decode(NotFoundPost.self))

                    case .blueskyFeedBlockedPost:
                        try self = .blueskyFeedBlockedPost(singleValueContainer.decode(BlockedPost.self))
                    }
                }
            }

            public let root: PostType
            public let parent: PostType
        }

        public class ReasonRepost: Decodable {
            private enum CodingKeys: CodingKey {
                case by
                case indexedAt
            }

            public let by: BskyActor.ProfileViewBasic
            public let indexedAt: Date

            required public init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)

                self.by = try container.decode(BskyActor.ProfileViewBasic.self, forKey: .by)

                let indexedAtString = try container.decode(String.self, forKey: .indexedAt)
                let dateFormatter = DateFormatter()

                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"

                self.indexedAt = dateFormatter.date(from: indexedAtString) ?? Date.distantPast
            }
        }

        public class ReasonPin: Decodable {

        }

        public class ThreadViewPost: Decodable {
            public indirect enum PostType: Decodable {
                private enum FieldType: String, Decodable {
                    case blueskyFeedThreadViewPost = "app.bsky.feed.defs#threadViewPost"
                    case blueskyFeedNotFoundPost = "app.bsky.feed.defs#notFoundPost"
                    case blueskyFeedBlockedPost = "app.bsky.feed.defs#blockedPost"
                }

                private enum CodingKeys: String, CodingKey {
                    case type = "$type"
                }

                case blueskyFeedThreadViewPost(ThreadViewPost)
                case blueskyFeedNotFoundPost(NotFoundPost)
                case blueskyFeedBlockedPost(BlockedPost)

                public init(from decoder: Decoder) throws {
                    let container = try decoder.container(keyedBy: CodingKeys.self)
                    let fieldType = try container.decode(FieldType.self, forKey: .type)
                    let singleValueContainer = try decoder.singleValueContainer()

                    switch fieldType {
                    case .blueskyFeedThreadViewPost:
                        try self = .blueskyFeedThreadViewPost(singleValueContainer.decode(ThreadViewPost.self))

                    case .blueskyFeedNotFoundPost:
                        try self = .blueskyFeedNotFoundPost(singleValueContainer.decode(NotFoundPost.self))

                    case .blueskyFeedBlockedPost:
                        try self = .blueskyFeedBlockedPost(singleValueContainer.decode(BlockedPost.self))
                    }
                }
            }

            public let post: PostView
            public let parent: PostType?
            public let replies: [PostType]?
        }

        public class NotFoundPost: Decodable {
            private enum CodingKeys: CodingKey {
                case uri
            }

            public let uri: String
            public let notFound: Bool

            required public init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)

                self.uri = try container.decode(String.self, forKey: .uri)
                self.notFound = true
            }
        }

        public class BlockedPost: Decodable {
            private enum CodingKeys: CodingKey {
                case uri
                case author
            }

            public let uri: String
            public let blocked: Bool
            public let author: BlockedAuthor

            required public init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)

                self.uri = try container.decode(String.self, forKey: .uri)
                self.blocked = true
                self.author = try container.decode(BlockedAuthor.self, forKey: .author)
            }
        }

        public class BlockedAuthor: Decodable {
            public let did: String
            public let viewer: ViewerState?
        }

        public class GeneratorView: Decodable {
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
            public let creator: BskyActor.ProfileView
            public let displayName: String
            public let avatar: String?
            public let likeCount: Int?
            public let viewer: GeneratorViewerState?
            public let indexedAt: Date

            required public init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)

                self.uri = try container.decode(String.self, forKey: .uri)
                self.cid = try container.decode(String.self, forKey: .cid)
                self.did = try container.decode(String.self, forKey: .did)
                self.creator = try container.decode(BskyActor.ProfileView.self, forKey: .creator)
                self.displayName = try container.decode(String.self, forKey: .displayName)
                self.avatar = try container.decodeIfPresent(String.self, forKey: .avatar)
                self.likeCount = try container.decodeIfPresent(Int.self, forKey: .likeCount)
                self.viewer = try container.decodeIfPresent(GeneratorViewerState.self, forKey: .viewer)

                let indexedAtString = try container.decode(String.self, forKey: .indexedAt)
                let dateFormatter = DateFormatter()

                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"

                self.indexedAt = dateFormatter.date(from: indexedAtString) ?? Date.distantPast
            }
        }

        public class GeneratorViewerState: Decodable {
            public let like: String?
        }

        public class SkeletonReasonRepost: Decodable {
            public let repost: String
        }

        public class SkeletonReasonPin: Decodable {

        }

        public class ThreadgateView: Decodable {
            public let uri: String?
            public let cid: String?
            public let record: AnyDecodable // FIXME: "record": { "type": "unknown" }
            public let lists: [Graph.ListViewBasic]
        }

        public class Interaction: Decodable {
            public enum InteractionType: String, Decodable {
                case requestLess = "app.bsky.feed.defs#requestLess"
                case requestMore = "app.bsky.feed.defs#requestMore"
                case clickthroughItem = "app.bsky.feed.defs#clickthroughItem"
                case clickthroughAuthor = "app.bsky.feed.defs#clickthroughAuthor"
                case clickthroughRepost = "app.bsky.feed.defs#clickthroughReposter"
                case clickthroughEmbed = "app.bsky.feed.defs#clickthroughEmbed"
                case interactionSeen = "app.bsky.feed.defs#interactionSeen"
                case interactionLike = "app.bsky.feed.defs#interactionLike"
                case interactionRepost = "app.bsky.feed.defs#interactionRepost"
                case interactionReply = "app.bsky.feed.defs#interactionReply"
                case interactionQyote = "app.bsky.feed.defs#interactionQuote"
                case interactionShare = "app.bsky.feed.defs#interactionShare"
            }

            public let item: String
            public let type: InteractionType
            public let feedContext: String
        }

        public class RequestLess: Decodable {
            public let token: Token
        }

        public class RequestMore: Decodable {
            public let token: Token
        }

        public class ClickthroughItem: Decodable {
            public let token: Token
        }

        public class ClickthroughAuthor: Decodable {
            public let token: Token
        }

        public class ClickthroughReposter: Decodable {
            public let token: Token
        }

        public class ClickthroughEmbed: Decodable {
            public let token: Token
        }

        public class InteractionSeen: Decodable {
            public let token: Token
        }

        public class InteractionLike: Decodable {
            public let token: Token
        }

        public class InteractionRepost: Decodable {
            public let token: Token
        }

        public class InteractionReply: Decodable {
            public let token: Token
        }

        public class InteractionQuote: Decodable {
            public let token: Token
        }

        public class InteractionShare: Decodable {
            public let token: Token
        }
    }
}
