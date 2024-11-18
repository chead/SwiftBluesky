//
//  BskyBskyActor.swift
//
//
//  Created by Christopher Head on 7/29/23.
//

import Foundation
import SwiftATProto

public extension Bsky {
    final class BskyActor {
        @propertyWrapper
        public class Indirect<Value: Decodable>: Decodable {
            var value: Value

            public init(wrappedValue initialValue: Value) {
                value = initialValue
            }

            public var wrappedValue: Value {
                get { value }
                set { value = newValue }
            }
        }

        public struct ProfileViewBasic: Hashable, Decodable {
            public let did: String
            public let handle: String
            public let displayName: String?
            public let avatar: String?
            public let viewer: ViewerState?
            public let labels: [ATProtoLabel]?
        }

        public struct ProfileView: Hashable, Decodable {
            public let did: String
            public let handle: String
            public let displayName: String?
            public let description: String?
            public let avatar: String?
            public let viewer: ViewerState?
            public let labels: [ATProtoLabel]?
        }

        public struct ProfileViewDetailed: Hashable, Decodable {
            private enum CodingKeys: CodingKey {
                case did
                case handle
                case displayName
                case description
                case avatar
                case banner
                case followsCount
                case followersCount
                case postsCount
                case indexedAt
                case viewer
                case labels
            }

            public let did: String
            public let handle: String
            public let displayName: String?
            public let description: String?
            public let avatar: String?
            public let banner: String?
            public let followsCount: Int?
            public let followersCount: Int?
            public let postsCount: Int?
            public let indexedAt: Date?
            public let viewer: ViewerState?
            public let labels: [ATProtoLabel]?

            public init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)

                self.did = try container.decode(String.self, forKey: .did)
                self.handle = try container.decode(String.self, forKey: .handle)
                self.displayName = try container.decodeIfPresent(String.self, forKey: .displayName)
                self.description = try container.decodeIfPresent(String.self, forKey: .description)
                self.avatar = try container.decodeIfPresent(String.self, forKey: .avatar)
                self.banner = try container.decodeIfPresent(String.self, forKey: .banner)
                self.followsCount = try container.decodeIfPresent(Int.self, forKey: .followsCount)
                self.followersCount = try container.decodeIfPresent(Int.self, forKey: .followersCount)
                self.postsCount = try container.decodeIfPresent(Int.self, forKey: .postsCount)

                if let indexedAtString = try container.decodeIfPresent(String.self, forKey: .indexedAt) {
                    let dateFormatter = DateFormatter()

                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"

                    self.indexedAt = dateFormatter.date(from: indexedAtString)
                } else {
                    self.indexedAt = nil
                }

                self.viewer = try container.decodeIfPresent(ViewerState.self, forKey: .viewer)
                self.labels = try container.decodeIfPresent([ATProtoLabel].self, forKey: .labels)
            }
        }

        public struct Profile: Codable {
            private enum CodingKeys: String, CodingKey {
                case type = "$type"
                case displayName
                case description
                case avatar
                case banner
                case labels
                case joinedViaStarterPack
                case pinnedPost
                case followersCount
                case createdAt
            }

            public let displayName: String?
            public let description: String?
            public let avatar: ATProtoBlob?
            public let banner: ATProtoBlob?
            public let labels: ATProtoSelfLabels?
            public let joinedViaStarterPack: ATProtoRepoStrongRef?
            public let pinnedPost: ATProtoRepoStrongRef?
            public let createdAt: Date?

            public init(displayName: String?, description: String?, avatar: ATProtoBlob?, banner: ATProtoBlob?, labels: ATProtoSelfLabels?, joinedViaStarterPack: ATProtoRepoStrongRef?, pinnedPost: ATProtoRepoStrongRef?, createdAt: Date?) {
                self.displayName = displayName
                self.description = description
                self.avatar = avatar
                self.banner = banner
                self.labels = labels
                self.joinedViaStarterPack = joinedViaStarterPack
                self.pinnedPost = pinnedPost
                self.createdAt = createdAt
            }

            public init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)

                self.displayName = try container.decodeIfPresent(String.self, forKey: .displayName)
                self.description = try container.decodeIfPresent(String.self, forKey: .description)
                self.avatar = try container.decodeIfPresent(ATProtoBlob.self, forKey: .avatar)
                self.banner = try container.decodeIfPresent(ATProtoBlob.self, forKey: .banner)
                self.labels = try container.decodeIfPresent(ATProtoSelfLabels.self, forKey: .labels)
                self.joinedViaStarterPack = try container.decodeIfPresent(ATProtoRepoStrongRef.self, forKey: .joinedViaStarterPack)
                self.pinnedPost = try container.decodeIfPresent(ATProtoRepoStrongRef.self, forKey: .pinnedPost)

                if let createdAtString = try container.decodeIfPresent(String.self, forKey: .createdAt) {
                    let dateFormatter = ISO8601DateFormatter()

                    self.createdAt = dateFormatter.date(from: createdAtString)
                } else {
                    self.createdAt = nil
                }
            }

            public func encode(to encoder: Encoder) throws {
                var container = encoder.container(keyedBy: CodingKeys.self)

                try container.encode("app.bsky.actor.profile", forKey: .type)
                try container.encodeIfPresent(displayName, forKey: .displayName)
                try container.encodeIfPresent(description, forKey: .description)
                try container.encodeIfPresent(avatar, forKey: .avatar)
                try container.encodeIfPresent(banner, forKey: .banner)
                try container.encodeIfPresent(labels, forKey: .labels)
                try container.encodeIfPresent(joinedViaStarterPack, forKey: .joinedViaStarterPack)
                try container.encodeIfPresent(pinnedPost, forKey: .pinnedPost)

                if let createdAt = createdAt {
                    let dateFormatter = ISO8601DateFormatter()

                    dateFormatter.formatOptions = [.withInternetDateTime]

                    try container.encode(dateFormatter.string(from: createdAt), forKey: .createdAt)
                }
            }
        }

        public struct ProfileAssociated: Decodable {
            public let lists: Int
            public let feedGens: Int
            public let starterPacks: Int
            public let labeler: Bool
            public let chat: ProfileAssociatedChat
        }

        public struct ProfileAssociatedChat: Decodable {
            public enum AllowIncomingType: String, Decodable {
                case all
                case none
                case following
            }

            public let allowIncoming: AllowIncomingType
        }

        public struct ViewerState: Hashable, Decodable {
            public let muted: Bool?
            @Indirect public var mutedByList: Graph.ListViewBasic?
            public let blockedBy: Bool?
            public let blocking: String?
            @Indirect public var blockingByList: Graph.ListViewBasic?
            public let following: String?
            public let followedBy: String?
            public let knownFollowers: KnownFollowers?

            public static func ==(lhs: ViewerState, rhs: ViewerState) -> Bool {
                lhs.muted == rhs.muted &&
                lhs.mutedByList == rhs.mutedByList &&
                lhs.blockedBy == rhs.blockedBy &&
                lhs.blocking == rhs.blocking &&
                lhs.blockingByList == rhs.blockingByList &&
                lhs.following == rhs.followedBy &&
                lhs.knownFollowers == rhs.knownFollowers
            }

            public func hash(into hasher: inout Hasher) {
                hasher.combine(muted)
                hasher.combine(mutedByList)
                hasher.combine(blockedBy)
                hasher.combine(blocking)
                hasher.combine(blockingByList)
                hasher.combine(following)
                hasher.combine(knownFollowers)
            }
        }

        public struct KnownFollowers: Hashable, Decodable {
            public let count: Int
            public let followers: [ProfileViewBasic]
        }
    }
}
