//
//  Facet.swift
//  SwiftBluesky
//
//  Created by Christopher Head on 11/10/24.
//

public extension Bsky.Richtext {
    class Facet: Codable {
        public struct Mention: Codable {
            let did: String
        }

        public struct Link: Codable {
            let uri: String
        }

        public struct Tag: Codable {
            let tag: String
        }

        public struct ByteSlice: Codable {
            let byteStart: Int
            let byteEnd: Int
        }

        public enum FeaturesType: Codable {
            private enum FieldType: String, Decodable {
                case mention = "#mention"
                case link = "#link"
                case tag = "#tag"
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