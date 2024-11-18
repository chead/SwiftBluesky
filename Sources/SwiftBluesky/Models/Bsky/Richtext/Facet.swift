//
//  Facet.swift
//  SwiftBluesky
//
//  Created by Christopher Head on 11/10/24.
//

public extension Bsky.Richtext {
    struct Facet: Hashable, Codable {
        public struct Mention: Hashable, Codable {
            public let did: String
        }

        public struct Link: Hashable, Codable {
            public let uri: String
        }

        public struct Tag: Hashable, Codable {
            public let tag: String
        }

        public struct ByteSlice: Hashable, Codable {
            public let byteStart: Int
            public let byteEnd: Int
        }

        public enum FeaturesType: Hashable, Codable {
            private enum FieldType: String, Decodable {
                case mention = "app.bsky.richtext.facet#mention"
                case link = "app.bsky.richtext.facet#link"
                case tag = "app.bsky.richtext.facet#tag"
            }

            private enum CodingKeys: String, CodingKey {
                case type = "$type"
            }

            case mention(Mention)
            case link(Link)
            case tag(Tag)

            public init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                let fieldType = try container.decode(FieldType.self, forKey: .type)
                let singleValueContainer = try decoder.singleValueContainer()

                switch fieldType {
                case .mention:
                    try self = .mention(singleValueContainer.decode(Mention.self))

                case .link:
                    try self = .link(singleValueContainer.decode(Link.self))

                case .tag:
                    try self = .tag(singleValueContainer.decode(Tag.self))
                }
            }

            public func encode(to encoder: any Encoder) throws {
                var container = encoder.singleValueContainer()

                switch(self) {
                case .mention(let mention):
                    try container.encode(mention)

                case .link(let link):
                    try container.encode(link)

                case .tag(let tag):
                    try container.encode(tag)
                }
            }
        }

        public let index: ByteSlice
        public let features: [FeaturesType]

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            try container.encode(index, forKey: .index)
            try container.encode(features, forKey: .index)
        }
    }
}
