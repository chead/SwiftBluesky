//
//  BskyEmbedVideo.swift
//  SwiftBluesky
//
//  Created by Christopher Head on 11/10/24.
//

import SwiftATProto

public extension Bsky.Embed {
    struct Video: Hashable, Decodable {
        public struct View: Hashable, Decodable {
            public let cid: String
            public let playlist: String
            public let thumbnail: String?
            public let alt: String?
            public let aspectRatio: AspectRatio?
        }

        public struct Caption: Hashable, Decodable {
            public let lang: String
            public let file: ATProtoBlob
        }

        public let video: ATProtoBlob
        public let captions: [Caption]?
        public let alt: String?
        public let aspectRatio: AspectRatio?
    }
}
