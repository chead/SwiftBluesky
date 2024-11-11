//
//  app.bsky.graph.swift
//  SwiftBluesky
//
//  Created by Christopher Head on 11/9/24.
//

import Foundation
import SwiftATProto
import AnyCodable

public extension Bsky {
    class Graph {
        public class ListViewBasic: Decodable {
            private enum CodingKeys: CodingKey {
                case uri
                case cid
                case creator
                case name
                case purpose
                case avatar
                case listItemCount
                case viewer
                case indexedAt
            }

            public let uri: String
            public let cid: String
            public let creator: BskyActor.ProfileView
            public let name: String
            public let purpose: ListPurpose
            public let avatar: String?
            public let listItemCount: Int?
            public let viewer: ListViewerState?
            public let indexedAt: Date?

            required public init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)

                self.uri = try container.decode(String.self, forKey: .uri)
                self.cid = try container.decode(String.self, forKey: .cid)
                self.creator = try container.decode(BskyActor.ProfileView.self, forKey: .creator)
                self.name = try container.decode(String.self, forKey: .name)
                self.purpose = try container.decode(ListPurpose.self, forKey: .purpose)
                self.avatar = try container.decodeIfPresent(String.self, forKey: .avatar)
                self.listItemCount = try container.decodeIfPresent(Int.self, forKey: .listItemCount)
                self.viewer = try container.decodeIfPresent(ListViewerState.self, forKey: .viewer)

                if let indexedAtString = try container.decodeIfPresent(String.self, forKey: .indexedAt) {
                    let dateFormatter = DateFormatter()

                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"

                    self.indexedAt = dateFormatter.date(from: indexedAtString)
                } else {
                    self.indexedAt = nil
                }
            }
        }

        public class ListView: Decodable {
            private enum CodingKeys: CodingKey {
                case uri
                case cid
                case creator
                case name
                case purpose
                case description
                case descriptionFacets
                case avatar
                case listItemCount
                case viewer
                case indexedAt
            }

            public let uri: String
            public let cid: String
            public let creator: BskyActor.ProfileView
            public let name: String
            public let purpose: ListPurpose
            public let description: String?
            public let descriptionFacets: [Bsky.Richtext.Facet]?
            public let avatar: String?
            public let listItemCount: Int?
            public let viewer: ListViewerState?
            public let indexedAt: Date

            required public init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                self.uri = try container.decode(String.self, forKey: .uri)
                self.cid = try container.decode(String.self, forKey: .cid)
                self.creator = try container.decode(BskyActor.ProfileView .self, forKey: .creator)
                self.name = try container.decode(String.self, forKey: .name)
                self.purpose = try container.decode(ListPurpose.self, forKey: .purpose)
                self.description = try container.decodeIfPresent(String.self, forKey: .description)
                self.descriptionFacets = try container.decodeIfPresent([Bsky.Richtext.Facet].self, forKey: .descriptionFacets)
                self.avatar = try container.decodeIfPresent(String.self, forKey: .avatar)
                self.listItemCount = try container.decodeIfPresent(Int.self, forKey: .listItemCount)
                self.viewer = try container.decodeIfPresent(ListViewerState.self, forKey: .viewer)

                let indexedAtString = try container.decode(String.self, forKey: .indexedAt)
                let dateFormatter = DateFormatter()

                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"

                self.indexedAt = dateFormatter.date(from: indexedAtString) ?? Date.distantPast
            }
        }

        public class ListItemView: Decodable {
            public let uri: String
            public let subject: BskyActor.ProfileView
        }

        public class StarterPackView: Decodable {
            private enum CodingKeys: CodingKey {
                case uri
                case cid
                case record
                case creator
                case list
                case listItemSample
                case feeds
                case joinedWeekCount
                case joinedAllTimeCount
                case labels
                case indexedAt
            }

            public let uri: String
            public let cid: String
            public let record: AnyDecodable // FIXME: "record": { "type": "unknown" }
            public let creator: BskyActor.ProfileViewBasic
            public let list: ListViewBasic?
            public let listItemSample: [ListItemView]?
            public let feeds: [Feed.GeneratorView]?
            public let joinedWeekCount: Int?
            public let joinedAllTimeCount: Int?
            public let labels: [ATProtoLabel]?
            public let indexedAt: Date

            required public init(from decoder: any Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)

                self.uri = try container.decode(String.self, forKey: .uri)
                self.cid = try container.decode(String.self, forKey: .cid)
                self.record = try container.decode(AnyDecodable.self, forKey: .record)
                self.creator = try container.decode(BskyActor.ProfileViewBasic.self, forKey: .creator)
                self.list = try container.decodeIfPresent(Graph.ListViewBasic.self, forKey: .list)
                self.listItemSample = try container.decodeIfPresent([Graph.ListItemView].self, forKey: .listItemSample)
                self.feeds = try container.decodeIfPresent([Feed.GeneratorView].self, forKey: .feeds)
                self.joinedWeekCount = try container.decodeIfPresent(Int.self, forKey: .joinedWeekCount)
                self.joinedAllTimeCount = try container.decodeIfPresent(Int.self, forKey: .joinedAllTimeCount)
                self.labels = try container.decodeIfPresent([ATProtoLabel].self, forKey: .labels)

                let indexedAtString = try container.decode(String.self, forKey: .indexedAt)
                let dateFormatter = DateFormatter()

                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"

                self.indexedAt = dateFormatter.date(from: indexedAtString) ?? Date.distantPast
            }
        }

        public class StarterPackViewBasic: Decodable {
            enum CodingKeys: CodingKey {
                case uri
                case cid
                case record
                case creator
                case listItemCount
                case joinedWeekCount
                case joinedAllTimeCount
                case labels
                case indexedAt
            }

            public let uri: String
            public let cid: String
            public let record: AnyDecodable // FIXME: "record": { "type": "unknown" }
            public let creator: BskyActor.ProfileViewBasic
            public let listItemCount: Int?
            public let joinedWeekCount: Int?
            public let joinedAllTimeCount: Int?
            public let labels: [ATProtoLabel]?
            public let indexedAt: Date

            required public init(from decoder: any Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                self.uri = try container.decode(String.self, forKey: .uri)
                self.cid = try container.decode(String.self, forKey: .cid)
                self.record = try container.decode(AnyDecodable.self, forKey: .record)
                self.creator = try container.decode(BskyActor.ProfileViewBasic.self, forKey: .creator)
                self.listItemCount = try container.decodeIfPresent(Int.self, forKey: .listItemCount)
                self.joinedWeekCount = try container.decodeIfPresent(Int.self, forKey: .joinedWeekCount)
                self.joinedAllTimeCount = try container.decodeIfPresent(Int.self, forKey: .joinedAllTimeCount)
                self.labels = try container.decodeIfPresent([ATProtoLabel].self, forKey: .labels)

                let indexedAtString = try container.decode(String.self, forKey: .indexedAt)
                let dateFormatter = DateFormatter()

                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"

                self.indexedAt = dateFormatter.date(from: indexedAtString) ?? Date.distantPast
            }
        }

        public class ListPurpose: Decodable {
            public enum ListPurposeType: String, Decodable {
                case bskyGraphModList = "app.bsky.graph.defs#modlist"
                case bskyGraphCurateList = "app.bsky.graph.defs#curatelist"
                case bskyGraphReferenceList = "app.bsky.graph.defs#referencelist"
            }

            public let type: ListPurposeType
        }

        public class ModList: Decodable {
            public let type: Token
        }

        public class CurateList: Decodable {
            public let type: Token
        }

        public class ReferenceList: Decodable {
            public let type: Token
        }

        public class ListViewerState: Decodable {
            public let muted: Bool
            public let blocked: String
        }

        public class NotFoundActor: Decodable {
            public let actor: String
            public let notFound: Bool

            enum CodingKeys: CodingKey {
                case actor
                case notFound
            }

            public required init(from decoder: any Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                self.actor = try container.decode(String.self, forKey: .actor)
                self.notFound = true
            }
        }

        public class Relationship: Decodable {
            public let did: String
            public let following: String
            public let followedBy: String
        }
    }
}
