//
//  BskyEmbedImages.swift
//  SwiftBluesky
//
//  Created by Christopher Head on 11/10/24.
//

import SwiftATProto

public extension Bsky.Embed {
    struct Images: Decodable {
        public struct ViewImage: Decodable {
            public let thumb: String
            public let fullsize: String
            public let alt: String
            public let aspectRatio: AspectRatio?
        }

        public struct View: Decodable {
            public let images: [ViewImage]
        }

        public struct Image: Decodable {
            public enum ImageType: Decodable {
                case atProtoBlob(ATProtoBlob)
                case atProtoImageBlob(ATProtoImageBlob)

                public init(from decoder: Decoder) throws {
                    let singleValueContainer = try decoder.singleValueContainer()

                    if let atProtoBlob = try? singleValueContainer.decode(ATProtoBlob.self) {
                        self = .atProtoBlob(atProtoBlob)
                    }
                    else if let atProtoImageBlob = try? singleValueContainer.decode(ATProtoImageBlob.self) {
                        self = .atProtoImageBlob(atProtoImageBlob)
                    }
                    else {
                        throw DecodingError.dataCorrupted(.init(codingPath: decoder.codingPath,
                                                                debugDescription: "Blob not found."))
                    }
                }
            }

            public let image: ImageType
            public let alt: String
            public let aspectRatio: AspectRatio?
        }

        public let images: [Image]
    }
}
