//
//  Post.swift
//  SwiftBluesky
//
//  Created by Christopher Head on 11/11/24.
//

import Foundation
import SwiftATProto

public extension Bsky.Feed {
    class Post: Codable {
        private enum CodingKeys: CodingKey {
            case text
            case facets
            case reply
            case embed
            case langs
            case labels
            case tags
            case createdAt
        }

        public indirect enum EmbedType: Decodable {
            private enum FieldType: String, Decodable {
                case images = "app.bsky.embed.images"
                case external = "app.bsky.embed.external"
                case record = "app.bsky.embed.record"
                case recordWithMedia = "app.bsky.embed.recordWithMedia"
                case video = "app.bsky.embed.video"
            }

            private enum CodingKeys: String, CodingKey {
                case type = "$type"
            }

            case images(Bsky.Embed.Images)
            case external(Bsky.Embed.External)
            case record(Bsky.Embed.Record)
            case recordWithMedia(Bsky.Embed.RecordWithMedia)
            case video(Bsky.Embed.Video)

            public init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                let fieldType = try container.decode(FieldType.self, forKey: .type)
                let singleValueContainer = try decoder.singleValueContainer()

                switch fieldType {
                case .images:
                    try self = .images(singleValueContainer.decode(Bsky.Embed.Images.self))

                case .external:
                    try self = .external(singleValueContainer.decode(Bsky.Embed.External.self))

                case .record:
                    try self = .record(singleValueContainer.decode(Bsky.Embed.Record.self))

                case .recordWithMedia:
                    try self = .recordWithMedia(singleValueContainer.decode(Bsky.Embed.RecordWithMedia.self))

                case .video:
                    try self = .video(singleValueContainer.decode(Bsky.Embed.Video.self))
                }
            }
        }

        public let text: String
        public let facets: [Bsky.Richtext.Facet]?
        public let reply: PostReplyRef?
        public let embed: EmbedType?
        public let langs: [String]?
        public let labels: [ATProtoSelfLabel]?
        public let tags: [String]?
        public let createdAt: Date

        required public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            self.text = try container.decode(String.self, forKey: .text)
            self.facets = try container.decodeIfPresent([Bsky.Richtext.Facet].self, forKey: .facets)
            self.reply = try container.decodeIfPresent(PostReplyRef.self, forKey: .reply)
            self.langs = try container.decodeIfPresent([String].self, forKey: .langs)
            self.labels = try container.decodeIfPresent([ATProtoSelfLabel].self, forKey: .labels)
            self.tags = try container.decodeIfPresent([String].self, forKey: .labels)
            self.embed = try container.decodeIfPresent(EmbedType.self, forKey: .embed)

            let createdAtString = try container.decode(String.self, forKey: .createdAt)
            let dateFormatter = DateFormatter()

            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"

            self.createdAt = dateFormatter.date(from: createdAtString) ?? Date.distantPast
        }

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            try container.encode(text, forKey: .text)
            try container.encode(facets, forKey: .facets)
            try container.encode(reply, forKey: .reply)
            try container.encode(langs, forKey: .langs)
            try container.encode(labels, forKey: .labels)
            try container.encode(tags, forKey: .tags)

            let dateFormatter = DateFormatter()

            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"

            try container.encode(dateFormatter.string(from: self.createdAt), forKey: .createdAt)
        }
    }

    struct PostReplyRef: Codable {
        public let root: ATProtoRepoStrongRef
        public let parent: ATProtoRepoStrongRef
    }
}
