//
//  Labeler.swift
//  SwiftBluesky
//
//  Created by Christopher Head on 11/11/24.
//

import Foundation
import SwiftATProto

public extension Bsky {
    final class Labeler {
        public struct LabelerView: Hashable, Decodable {
            private enum CodingKeys: CodingKey {
                case uri
                case cid
                case creator
                case likeCount
                case viewer
                case indexedAt
                case labels
            }

            public let uri: String
            public let cid: String
            public let creator: BskyActor.ProfileView
            public let likeCount: Int?
            public let viewer: LabelerViewerState?
            public let indexedAt: Date
            public let labels: [ATProtoLabel]?

            public init(from decoder: any Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)

                self.uri = try container.decode(String.self, forKey: .uri)
                self.cid = try container.decode(String.self, forKey: .cid)
                self.creator = try container.decode(BskyActor.ProfileView.self, forKey: .creator)
                self.likeCount = try container.decodeIfPresent(Int.self, forKey: .likeCount)
                self.viewer = try container.decodeIfPresent(LabelerViewerState.self, forKey: .viewer)

                let indexedAtString = try container.decode(String.self, forKey: .indexedAt)

                let dateFormatter = DateFormatter()

                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"

                self.indexedAt = dateFormatter.date(from: indexedAtString) ?? Date.distantPast

                self.labels = try container.decodeIfPresent([ATProtoLabel].self, forKey: .labels)
            }
        }

        public struct LabelerViewerState: Hashable, Decodable {
            public let like: String?
        }
    }
}
