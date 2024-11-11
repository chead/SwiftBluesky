//
//  BskyEmbedRecord.swift
//  SwiftBluesky
//
//  Created by Christopher Head on 11/10/24.
//

import Foundation
import SwiftATProto
import AnyCodable

public extension BskyApp.Bsky.Embed {
    class Record: Decodable {
        public class View: Decodable {
            public enum RecordType: Decodable {
                private enum FieldType: String, Decodable {
                    case recordViewRecord = "app.bsky.embed.record#viewRecord"
                    case recordViewNotFound = "app.bsky.embed.record#viewNotFound"
                    case recordViewBlocked = "app.bsky.embed.record#viewBlocked"
                    case feedGeneratorView = "app.bsky.feed.defs#generatorView"
                    case graphListView = "app.bsky.graph.defs#listView"
                }

                private enum CodingKeys: String, CodingKey {
                    case type = "$type"
                }

                case recordViewRecord(ViewRecord)
                case recordViewNotFound(ViewNotFound)
                case recordViewBlocked(ViewBlocked)
                case feedGeneratorView(BskyApp.Bsky.Feed.GeneratorView)
                case graphListView(BskyApp.Bsky.Graph.ListView)

                public init(from decoder: Decoder) throws {
                    let container = try decoder.container(keyedBy: CodingKeys.self)
                    let fieldType = try container.decode(FieldType.self, forKey: .type)
                    let singleValueContainer = try decoder.singleValueContainer()

                    switch fieldType {
                    case .recordViewRecord:
                        try self = .recordViewRecord(singleValueContainer.decode(ViewRecord.self))

                    case .recordViewNotFound:
                        try self = .recordViewNotFound(singleValueContainer.decode(ViewNotFound.self))

                    case .recordViewBlocked:
                        try self = .recordViewBlocked(singleValueContainer.decode(ViewBlocked.self))

                    case .feedGeneratorView:
                        try self = .feedGeneratorView(singleValueContainer.decode(BskyApp.Bsky.Feed.GeneratorView.self))

                    case .graphListView:
                        try self = .graphListView(singleValueContainer.decode(BskyApp.Bsky.Graph.ListView.self))
                    }
                }
            }

            public let record: RecordType
        }

        public class ViewRecord: Decodable {
            private enum CodingKeys: CodingKey {
                case uri
                case cid
                case author
                case value
                case labels
                case embeds
                case indexedAt
            }

            public enum EmbedType: Decodable {
                private enum FieldType: String, Decodable {
                    case imagesView = "app.bsky.embed.images#view"
                    case externalView = "app.bsky.embed.external#view"
                    case recordView = "app.bsky.embed.record#view"
                    case recordWithMediaView = "app.bsky.embed.recordWithMedia#view"
                    case videoView = "app.bsky.embed.video#view"
                }

                private enum CodingKeys: String, CodingKey {
                    case type = "$type"
                }

                case imagesView(Images.View)
                case externalView(External.View)
                case recordView(View)
                case recordWithMediaView(RecordWithMedia.View)
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

                    case .recordView:
                        try self = .recordView(singleValueContainer.decode(View.self))

                    case .recordWithMediaView:
                        try self = .recordWithMediaView(singleValueContainer.decode(RecordWithMedia.View.self))

                    case .videoView:
                        try self = .videoView(singleValueContainer.decode(Video.View.self))
                    }
                }
            }

            public let uri: String
            public let cid: String
            public let author: BskyApp.Bsky.BskyActor.ProfileViewBasic
            public let value: AnyDecodable
            public let labels: [ATProtoLabel]?
            public let embeds: [EmbedType]?
            public let indexedAt: Date

            required public init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)

                self.uri = try container.decode(String.self, forKey: .uri)
                self.cid = try container.decode(String.self, forKey: .cid)
                self.author = try container.decode(BskyApp.Bsky.BskyActor.ProfileViewBasic.self, forKey: .author)
                self.value = try container.decode(AnyDecodable.self, forKey: .value)
                self.labels = try container.decodeIfPresent([ATProtoLabel].self, forKey: .labels)
                self.embeds = try container.decodeIfPresent([EmbedType].self, forKey: .embeds)

                let indexedAtString = try container.decode(String.self, forKey: .indexedAt)

                let dateFormatter = DateFormatter()

                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"

                self.indexedAt = dateFormatter.date(from: indexedAtString) ?? Date.distantPast
            }
        }

        public class ViewNotFound: Decodable {
            private enum CodingKeys: CodingKey {
                case uri
            }

            public let uri: String
            public let notFound: Bool = true

            required public init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)

                self.uri = try container.decode(String.self, forKey: .uri)
            }
        }

        public class ViewBlocked: Decodable {
            private enum CodingKeys: CodingKey {
                case uri
                case author
            }

            public let uri: String
            public let blocked: Bool = true
            public let author: BskyApp.Bsky.Feed.BlockedAuthor

            required public init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)

                self.uri = try container.decode(String.self, forKey: .uri)
                self.author = try container.decode(BskyApp.Bsky.Feed.BlockedAuthor.self, forKey: .author)
            }
        }

        public let record: ATProtoRepoStrongRef
    }
}
