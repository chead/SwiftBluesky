//
//  BskyEmbedRecordWithMedia.swift
//  SwiftBluesky
//
//  Created by Christopher Head on 11/10/24.
//

public extension Bsky.Embed {
    class RecordWithMedia: Decodable {
        public enum MediaType: Decodable {
            private enum FieldType: String, Decodable {
                case blueskyEmbedImages = "app.bsky.embed.images"
                case blueskyEmbedExternal = "app.bsky.embed.external"
                case blueskyEmbedVideo = "app.bsky.embed.video"
            }

            private enum CodingKeys: String, CodingKey {
                case type = "$type"
            }

            case blueskyEmbedImages(Images)
            case blueskyEmbedExternal(External)
            case blueskyEmbedVideo(Video)

            public init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                let fieldType = try container.decode(FieldType.self, forKey: .type)
                let singleValueContainer = try decoder.singleValueContainer()

                switch fieldType {
                case .blueskyEmbedImages:
                    try self = .blueskyEmbedImages(singleValueContainer.decode(Images.self))

                case .blueskyEmbedExternal:
                    try self = .blueskyEmbedExternal(singleValueContainer.decode(External.self))

                case .blueskyEmbedVideo:
                    try self = .blueskyEmbedVideo(singleValueContainer.decode(Video.self))
                }
            }
        }

        public class View: Decodable {
            public enum MediaType: Decodable {
                private enum FieldType: String, Decodable {
                    case imagesView = "app.bsky.embed.images#view"
                    case externalView = "app.bsky.embed.external#view"
                    case videoView = "app.bsky.embed.video#view"
                }

                private enum CodingKeys: String, CodingKey {
                    case type = "$type"
                }

                case imagesView(Images.View)
                case externalView(External.View)
                case videoView(Video.View)

                public init(from decoder: Decoder) throws {
                    let container = try decoder.container(keyedBy: CodingKeys.self)
                    let fieldType = try container.decode(FieldType.self, forKey: .type)
                    let singleValueContainer = try decoder.singleValueContainer()

                    switch fieldType {
                    case .imagesView:
                        try self = .imagesView(singleValueContainer.decode(Images.View.self))

                    case .externalView:
                        try self = .externalView(singleValueContainer.decode(External.View.self))

                    case .videoView:
                        try self = .videoView(singleValueContainer.decode(Video.View.self))
                    }
                }
            }

            public let record: Record
            public let media: MediaType
        }

        public let record: Record
        public let media: MediaType
    }
}
