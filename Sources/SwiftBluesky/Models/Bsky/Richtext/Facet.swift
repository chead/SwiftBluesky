//
//  Facet.swift
//  SwiftBluesky
//
//  Created by Christopher Head on 11/10/24.
//

public extension Bsky.Richtext {
    class Facet: Decodable {
        public struct Mention: Decodable {
            let did: String
        }

        public struct Link: Decodable {
            let uri: String
        }

        public struct Tag: Decodable {
            let tag: String
        }

        public struct ByteSlice: Decodable {
            let byteStart: Int
            let byteEnd: Int
        }

        public enum FeaturesType: Decodable {
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
        }

        public let index: ByteSlice
        public let features: [FeaturesType]
    }
}
