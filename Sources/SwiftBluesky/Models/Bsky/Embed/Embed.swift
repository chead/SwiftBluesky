//
//  BlueskyEmbed.swift
//
//
//  Created by Christopher Head on 7/29/23.
//

public extension Bsky {
    final class Embed {
        public struct AspectRatio: Hashable, Decodable {
            public let width: Int
            public let height: Int
        }
    }
}
