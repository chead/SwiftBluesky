//
//  Repost.swift
//  SwiftBluesky
//
//  Created by Christopher Head on 11/10/24.
//

import Foundation
import SwiftATProto

public extension Bsky.Feed {
    class Repost: Encodable {
        private enum CodingKeys: CodingKey {
            case subject
            case createdAt
        }

        public let subject: ATProtoRepoStrongRef
        public let createdAt: Date

        public init(subject: ATProtoRepoStrongRef, createdAt: Date) {
            self.subject = subject
            self.createdAt = createdAt
        }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            try container.encode(subject, forKey: .subject)

            let dateFormatter = ISO8601DateFormatter()

            dateFormatter.formatOptions = [.withInternetDateTime]

            try container.encode(dateFormatter.string(from: self.createdAt), forKey: .createdAt)
        }
    }
}
