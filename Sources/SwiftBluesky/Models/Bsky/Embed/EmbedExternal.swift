//
//  BskyEmbedExternal.swift
//  SwiftBluesky
//
//  Created by Christopher Head on 11/10/24.
//

import SwiftATProto

public extension Bsky.Embed {
    struct External: Decodable {
        public struct External: Decodable {
            public let uri: String
            public let title: String
            public let description: String
            public let thumb: ATProtoBlob?
        }

        public struct View: Decodable {
            public let external: ViewExternal
        }

        public struct ViewExternal: Decodable {
            public let uri: String
            public let description: String
            public let thumb: String?
        }

        public let external: External
    }
}
