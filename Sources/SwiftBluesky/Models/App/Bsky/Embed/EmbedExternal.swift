//
//  BskyEmbedExternal.swift
//  SwiftBluesky
//
//  Created by Christopher Head on 11/10/24.
//

import SwiftATProto

public extension BskyApp.Bsky.Embed {
    class External: Decodable {
        public class External: Decodable {
            public let uri: String
            public let title: String
            public let description: String
            public let thumb: ATProtoBlob?
        }

        public class View: Decodable {
            public let external: ViewExternal
        }

        public class ViewExternal: Decodable {
            public let uri: String
            public let description: String
            public let thumb: String?
        }

        public let external: External
    }
}
