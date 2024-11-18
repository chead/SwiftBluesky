//
//  PostViewTests.swift
//  SwiftBluesky
//
//  Created by Christopher Head on 11/11/24.
//

import XCTest
@testable import SwiftBluesky

final class PostViewTests: XCTestCase {
    func testDecodeFromJSON() throws {
        let postViewJSONData = #"""
        {
            "uri": "at://did:plc:7bfmklk2nqmul75fwhocsb2a/app.bsky.feed.post/3lap3ipjc7c2h",
            "cid": "bafyreifbfn4dw7er77dlecjmf3azcmsazrt4lweh5f5bl2aqd3kgsq443m",
            "author": {
                "did": "did:plc:7bfmklk2nqmul75fwhocsb2a",
                "handle": "clemfox.bsky.social",
                "displayName": "Clementine クレメンタイン 🔜MFF",
                "avatar": "https://cdn.bsky.app/img/avatar/plain/did:plc:7bfmklk2nqmul75fwhocsb2a/bafkreid4pnagw4o5mi2p6sx6cholkcmodyns7t7q4rb6y3ygnnilhvrmim@jpeg",
                "associated": {
                    "chat": {
                        "allowIncoming": "following"
                    }
                },
                "viewer": {
                    "muted": false,
                    "blockedBy": false
                },
                "labels": [{
                    "src": "did:plc:7bfmklk2nqmul75fwhocsb2a",
                    "uri": "at://did:plc:7bfmklk2nqmul75fwhocsb2a/app.bsky.actor.profile/self",
                    "cid": "bafyreiec5tpeylpcavn3nglg7ehffdjh443emklyui5gsyde3jmhad3l64",
                    "val": "!no-unauthenticated",
                    "cts": "1970-01-01T00:00:00.000Z"
                }],
                "createdAt": "2023-07-24T21:52:32.643Z"
            },
            "record": {
                "$type": "app.bsky.feed.post",
                "createdAt": "2024-11-11T19:47:02.648Z",
                "embed": {
                    "$type": "app.bsky.embed.record",
                    "record": {
                        "cid": "bafyreibin6dpp6kepaormarwzrzlx3zf4xabacuzp5lq34dhmtwcvrzweq",
                        "uri": "at://did:plc:e4elbtctnfqocyfcml6h2lf7/app.bsky.graph.list/3l53cjwlt4o2s"
                    }
                },
                "facets": [{
                    "features": [{
                        "$type": "app.bsky.richtext.facet#link",
                        "uri": "https://bsky.app/profile/did:plc:e4elbtctnfqocyfcml6h2lf7/lists/3l53cjwlt4o2s"
                    }],
                    "index": {
                        "byteEnd": 143,
                        "byteStart": 119
                    }
                }],
                "langs": ["en"],
                "text": "M4G4 block list for you all! Make sure to remove any of the keywords in your profile to avoid being caught in the net!\nbsky.app/profile/did:..."
            },
            "embed": {
                "$type": "app.bsky.embed.record#view",
                "record": {
                    "uri": "at://did:plc:e4elbtctnfqocyfcml6h2lf7/app.bsky.graph.list/3l53cjwlt4o2s",
                    "cid": "bafyreibin6dpp6kepaormarwzrzlx3zf4xabacuzp5lq34dhmtwcvrzweq",
                    "name": "MAGA",
                    "purpose": "app.bsky.graph.defs#modlist",
                    "listItemCount": 423,
                    "indexedAt": "2024-09-26T18:44:10.021Z",
                    "labels": [],
                    "viewer": {
                        "muted": false
                    },
                    "creator": {
                        "did": "did:plc:e4elbtctnfqocyfcml6h2lf7",
                        "handle": "skywatch.blue",
                        "displayName": "Anti-Alf Aktion",
                        "avatar": "https://cdn.bsky.app/img/avatar/plain/did:plc:e4elbtctnfqocyfcml6h2lf7/bafkreidj56ewohaguhuksoqwo4cybck6vf5h3ssc4iarzvrrzdgzbc2rpa@jpeg",
                        "associated": {
                            "labeler": true,
                            "chat": {
                                "allowIncoming": "following"
                            }
                        },
                        "viewer": {
                            "muted": false,
                            "blockedBy": false
                        },
                        "labels": [],
                        "createdAt": "2024-02-20T06:15:04.884Z",
                        "description": "Ceaseless watcher, turn your endless gaze upon this wretched thing. A labeling service for all things Alf, as well as certain facts about content found in usernames, descriptions, and posts. Not regularly monitored.",
                        "indexedAt": "2024-10-19T02:33:35.040Z"
                    },
                    "description": "Username and / or description which includes MAGA, MAHA, TRUMP, or TRUMP 2024, or posts with #MAGA and #TRUMP2024 hashtags or clear indicators of support for Trump.",
                    "descriptionFacets": [{
                        "features": [{
                            "$type": "app.bsky.richtext.facet#tag",
                            "tag": "MAGA"
                        }],
                        "index": {
                            "byteEnd": 98,
                            "byteStart": 93
                        }
                    }, {
                        "features": [{
                            "$type": "app.bsky.richtext.facet#tag",
                            "tag": "TRUMP2024"
                        }],
                        "index": {
                            "byteEnd": 113,
                            "byteStart": 103
                        }
                    }],
                    "$type": "app.bsky.graph.defs#listView"
                }
            },
            "replyCount": 0,
            "repostCount": 2,
            "likeCount": 4,
            "quoteCount": 0,
            "indexedAt": "2024-11-11T19:47:02.648Z",
            "viewer": {
                "threadMuted": false,
                "embeddingDisabled": false
            },
            "labels": []
        }
        """#.data(using: .utf8)!

        _ = try JSONDecoder().decode(Bsky.Feed.PostView.self, from: postViewJSONData)
    }
}
