//
//  BlueskyFeedLike.swift
//
//
//  Created by Christopher Head on 2/7/24.
//

import Foundation
import SwiftATProto

public struct BlueskyFeedLike: Codable {
    public let subject: ATProtoRepoStrongRef
    public let createdAt: Date

    private enum CodingKeys: CodingKey {
        case subject
        case createdAt
    }

    public init(subject: ATProtoRepoStrongRef, createdAt: Date) {
        self.subject = subject
        self.createdAt = createdAt
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.subject = try container.decode(ATProtoRepoStrongRef.self, forKey: .subject)

        let createdAtString = try container.decode(String.self, forKey: .createdAt)

        self.createdAt = ISO8601DateFormatter().date(from: createdAtString) ?? Date.distantPast
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self.subject, forKey: .subject)

        let dateFormatter = ISO8601DateFormatter()

        dateFormatter.formatOptions = [.withInternetDateTime]

        try container.encode(dateFormatter.string(from: self.createdAt), forKey: .createdAt)
    }
}
