//
//  BskyEmbedExternal.swift
//  SwiftBluesky
//
//  Created by Christopher Head on 11/10/24.
//

import SwiftATProto

public extension Bsky.Embed {
    struct External: Hashable, Decodable {
        public struct External: Hashable, Decodable {
            public let uri: String
            public let title: String
            public let description: String
            public let thumb: ATProtoBlob?
        }

        public struct View: Hashable, Decodable {
            public let external: ViewExternal
        }

        public struct ViewExternal: Hashable, Decodable {
            public let uri: String
            public let description: String
            public let thumb: String?
        }

        public let external: External
    }
}
