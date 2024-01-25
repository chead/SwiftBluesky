import XCTest
@testable import SwiftBluesky

final class BlueskyClientTests: XCTestCase {
    @available(iOS 16.0, *)
    func testCreateSession() async throws {
        let blueskyClient = BlueskyClient()
        
        let createSessionResponse = try await blueskyClient.createSession(host: URL(string: "")!, identifier: "", password: "")

        switch createSessionResponse {
        case .success(let createSessionResponseValue):
            break

        case .failure(let error):
            break
        }
    }

    @available(iOS 16.0, *)
    func testGetProfiles() async throws {
        let blueskyClient = BlueskyClient()

        let getProfilesResponse = try await blueskyClient.getProfiles(host: URL(string: "")!, accessToken: "", refreshToken: "", actors: [])
        
//        switch createSessionResponse {
//        case .success(let createSessionResponseValue):
//            break
//
//        case .failure(_):
//            break
//        }
    }

    @available(iOS 16.0, *)
    func testGetAuthorFeed() async throws {
        let authorFeedJSONData = #"""
        {
            "feed": [{
                "post": {
                    "uri": "at://did:plc:i3xtmaoi6vysczm5c6v2iuxs/app.bsky.feed.post/3kjitqhkzqn2j",
                    "cid": "bafyreiarpfl6fstmfiudpaj7eoidagqfszfs5lp4fdy5j4dxujebhpbrvq",
                    "author": {
                        "did": "did:plc:i3xtmaoi6vysczm5c6v2iuxs",
                        "handle": "revelatrix.bsky.social",
                        "displayName": "Ohio is for Lydias",
                        "avatar": "https://cdn.bsky.app/img/avatar/plain/did:plc:i3xtmaoi6vysczm5c6v2iuxs/bafkreidmvo7otvyiuqu67lm34lvosfoig4qwtxgdbjogmtg47bugmuiyci@jpeg",
                        "viewer": {
                            "muted": false,
                            "blockedBy": false
                        },
                        "labels": []
                    },
                    "record": {
                        "text": "unlike you i get my news from a reliable source...",
                        "$type": "app.bsky.feed.post",
                        "embed": {
                            "$type": "app.bsky.embed.recordWithMedia",
                            "media": {
                                "$type": "app.bsky.embed.images",
                                "images": [{
                                    "alt": "a black-and-white illustration of Ningauble of the Seven Eyes, a mysterious, inhuman sorcerer from Fritz Leiber's Fafhrd and the Gray Mouser stories. Ningauble appears to be a bulbous or amorphous inhuman figure entirely hidden in voluminous robes, with a point of light shining from within the hood for each of his seven eyes. In this illustration, one of the eyes is currently extended out of the hood on a long, tentacle-like appendage to glance upward. Behind the sorcerer is a hookah or perhaps magic bong of some kind. Kinda based tbh",
                                    "image": {
                                        "$type": "blob",
                                        "ref": {
                                            "$link": "bafkreiertzz7w3qgslvm2lyxy7tae3pcmg6jr5phrbbkhmneb22wkc6vum"
                                        },
                                        "mimeType": "image/jpeg",
                                        "size": 308992
                                    },
                                    "aspectRatio": {
                                        "width": 668,
                                        "height": 924
                                    }
                                }]
                            },
                            "record": {
                                "$type": "app.bsky.embed.record",
                                "record": {
                                    "cid": "bafyreia2u4nrc2ftgyd374bepqsq3jgygvrlcra2l4nc6sdmpahprfpyrm",
                                    "uri": "at://did:plc:zljlg7cgdfsl7maqvjjpp7i4/app.bsky.feed.post/3kjikuzphnw25"
                                }
                            }
                        },
                        "langs": ["en"],
                        "createdAt": "2024-01-21T15:32:46.823Z"
                    },
                    "embed": {
                        "$type": "app.bsky.embed.recordWithMedia#view",
                        "record": {
                            "record": {
                                "$type": "app.bsky.embed.record#viewRecord",
                                "uri": "at://did:plc:zljlg7cgdfsl7maqvjjpp7i4/app.bsky.feed.post/3kjikuzphnw25",
                                "cid": "bafyreia2u4nrc2ftgyd374bepqsq3jgygvrlcra2l4nc6sdmpahprfpyrm",
                                "author": {
                                    "did": "did:plc:zljlg7cgdfsl7maqvjjpp7i4",
                                    "handle": "starshine.bsky.social",
                                    "displayName": "☀️ Starshine",
                                    "avatar": "https://cdn.bsky.app/img/avatar/plain/did:plc:zljlg7cgdfsl7maqvjjpp7i4/bafkreiddhnuvzpdtqqyv6tdoiuwn2lb6e3v32sdtvewkovsh5aqpobh4oe@jpeg",
                                    "viewer": {
                                        "muted": false,
                                        "blockedBy": false,
                                        "following": "at://did:plc:etdcb47v54mwv2wdufhi4tu6/app.bsky.graph.follow/3k2nlnceilg25",
                                        "followedBy": "at://did:plc:zljlg7cgdfsl7maqvjjpp7i4/app.bsky.graph.follow/3k2nlocyisc2t"
                                    },
                                    "labels": [{
                                        "src": "did:plc:zljlg7cgdfsl7maqvjjpp7i4",
                                        "uri": "at://did:plc:zljlg7cgdfsl7maqvjjpp7i4/app.bsky.actor.profile/self",
                                        "cid": "bafyreidqsrrsgiu5o7s5osays3horwcvuykkmin2i75efkyzyhj4a27waq",
                                        "val": "!no-unauthenticated",
                                        "cts": "1970-01-01T00:00:00.000Z",
                                        "neg": false
                                    }]
                                },
                                "value": {
                                    "text": "Unlike you i get my news from a realiable source…",
                                    "$type": "app.bsky.feed.post",
                                    "embed": {
                                        "$type": "app.bsky.embed.recordWithMedia",
                                        "media": {
                                            "$type": "app.bsky.embed.images",
                                            "images": [{
                                                "alt": "A bunch of small bones in a circlish triangle, their configuration says darkness will befall you, the light closes in, your screams will be heard naught as the terror closes in around you, you feel its icy grip clenching, surrender to it, give in, it consumes you. your soul belongs to them now your existence is but that of a shade eternally doomed to wander the endless halls tormented by desires that are forever denied. A thirst that can be quenched, a hunger that cant be satiated, the warmth of the sun but a memory. Food turns to ash and water to ice as they press your lips. All feelings grow numb but that pain, pain and torment. For the bones do not lie.",
                                                "image": {
                                                    "$type": "blob",
                                                    "ref": {
                                                        "$link": "bafkreig3wvaqzi4utrv6itkk3o26mbezr3326vluvdzcf4bsvya2qtyxl4"
                                                    },
                                                    "mimeType": "image/jpeg",
                                                    "size": 629681
                                                },
                                                "aspectRatio": {
                                                    "width": 2000,
                                                    "height": 1588
                                                }
                                            }]
                                        },
                                        "record": {
                                            "$type": "app.bsky.embed.record",
                                            "record": {
                                                "cid": "bafyreihhymwv6lkei5x3ah5p3l2dqlgpjousahz2mmfrym2cpaf2gcijva",
                                                "uri": "at://did:plc:aawupovstz4yqkxqe6awgaci/app.bsky.feed.post/3kjijdexmmm2d"
                                            }
                                        }
                                    },
                                    "langs": ["en"],
                                    "createdAt": "2024-01-21T12:54:16.318Z"
                                },
                                "labels": [],
                                "indexedAt": "2024-01-21T12:54:16.318Z",
                                "embeds": [{
                                    "$type": "app.bsky.embed.recordWithMedia#view",
                                    "record": {
                                        "record": {
                                            "$type": "app.bsky.embed.record#viewRecord",
                                            "uri": "at://did:plc:aawupovstz4yqkxqe6awgaci/app.bsky.feed.post/3kjijdexmmm2d",
                                            "cid": "bafyreihhymwv6lkei5x3ah5p3l2dqlgpjousahz2mmfrym2cpaf2gcijva",
                                            "author": {
                                                "did": "did:plc:aawupovstz4yqkxqe6awgaci",
                                                "handle": "vaguebiscuit.bsky.social",
                                                "displayName": "Glen",
                                                "avatar": "https://cdn.bsky.app/img/avatar/plain/did:plc:aawupovstz4yqkxqe6awgaci/bafkreid2ley56dhedsvorhhyeg6ocnzdxqnrg6ereaed4hnh4iv5sr5dme@jpeg",
                                                "viewer": {
                                                    "muted": false,
                                                    "blockedBy": false
                                                },
                                                "labels": []
                                            },
                                            "value": {
                                                "text": "Unlike you I get my news from a reliable source...",
                                                "$type": "app.bsky.feed.post",
                                                "embed": {
                                                    "$type": "app.bsky.embed.recordWithMedia",
                                                    "media": {
                                                        "$type": "app.bsky.embed.images",
                                                        "images": [{
                                                            "alt": "Donald Trump at one of his rallies. He looks like he's screaming and his hands are held.apart like he's showing you how big a fish was",
                                                            "image": {
                                                                "$type": "blob",
                                                                "ref": {
                                                                    "$link": "bafkreigzx2p4nm4g6bv6lv3s5ucqeup2qqi3pufxymzd5p47yxq55c74he"
                                                                },
                                                                "mimeType": "image/jpeg",
                                                                "size": 350389
                                                            },
                                                            "aspectRatio": {
                                                                "width": 1480,
                                                                "height": 833
                                                            }
                                                        }]
                                                    },
                                                    "record": {
                                                        "$type": "app.bsky.embed.record",
                                                        "record": {
                                                            "cid": "bafyreiaorfecfkabgcklhmvh6ux3beu2iktmry64l46iqj6b4zqaiy7f6q",
                                                            "uri": "at://did:plc:z4qvvpxlc3h34cslchnedmzn/app.bsky.feed.post/3kjigyoplht2z"
                                                        }
                                                    }
                                                },
                                                "langs": ["en"],
                                                "createdAt": "2024-01-21T12:26:29.540Z"
                                            },
                                            "labels": [],
                                            "indexedAt": "2024-01-21T12:26:29.540Z"
                                        }
                                    },
                                    "media": {
                                        "$type": "app.bsky.embed.images#view",
                                        "images": [{
                                            "thumb": "https://cdn.bsky.app/img/feed_thumbnail/plain/did:plc:zljlg7cgdfsl7maqvjjpp7i4/bafkreig3wvaqzi4utrv6itkk3o26mbezr3326vluvdzcf4bsvya2qtyxl4@jpeg",
                                            "fullsize": "https://cdn.bsky.app/img/feed_fullsize/plain/did:plc:zljlg7cgdfsl7maqvjjpp7i4/bafkreig3wvaqzi4utrv6itkk3o26mbezr3326vluvdzcf4bsvya2qtyxl4@jpeg",
                                            "alt": "A bunch of small bones in a circlish triangle, their configuration says darkness will befall you, the light closes in, your screams will be heard naught as the terror closes in around you, you feel its icy grip clenching, surrender to it, give in, it consumes you. your soul belongs to them now your existence is but that of a shade eternally doomed to wander the endless halls tormented by desires that are forever denied. A thirst that can be quenched, a hunger that cant be satiated, the warmth of the sun but a memory. Food turns to ash and water to ice as they press your lips. All feelings grow numb but that pain, pain and torment. For the bones do not lie.",
                                            "aspectRatio": {
                                                "width": 2000,
                                                "height": 1588
                                            }
                                        }]
                                    }
                                }]
                            }
                        },
                        "media": {
                            "$type": "app.bsky.embed.images#view",
                            "images": [{
                                "thumb": "https://cdn.bsky.app/img/feed_thumbnail/plain/did:plc:i3xtmaoi6vysczm5c6v2iuxs/bafkreiertzz7w3qgslvm2lyxy7tae3pcmg6jr5phrbbkhmneb22wkc6vum@jpeg",
                                "fullsize": "https://cdn.bsky.app/img/feed_fullsize/plain/did:plc:i3xtmaoi6vysczm5c6v2iuxs/bafkreiertzz7w3qgslvm2lyxy7tae3pcmg6jr5phrbbkhmneb22wkc6vum@jpeg",
                                "alt": "a black-and-white illustration of Ningauble of the Seven Eyes, a mysterious, inhuman sorcerer from Fritz Leiber's Fafhrd and the Gray Mouser stories. Ningauble appears to be a bulbous or amorphous inhuman figure entirely hidden in voluminous robes, with a point of light shining from within the hood for each of his seven eyes. In this illustration, one of the eyes is currently extended out of the hood on a long, tentacle-like appendage to glance upward. Behind the sorcerer is a hookah or perhaps magic bong of some kind. Kinda based tbh",
                                "aspectRatio": {
                                    "width": 668,
                                    "height": 924
                                }
                            }]
                        }
                    },
                    "replyCount": 0,
                    "repostCount": 3,
                    "likeCount": 11,
                    "indexedAt": "2024-01-21T15:32:46.823Z",
                    "viewer": {
                        "repost": "at://did:plc:etdcb47v54mwv2wdufhi4tu6/app.bsky.feed.repost/3kjivimniqz2d",
                        "like": "at://did:plc:etdcb47v54mwv2wdufhi4tu6/app.bsky.feed.like/3kjivil6lrf2f"
                    },
                    "labels": []
                },
                "reason": {
                    "$type": "app.bsky.feed.defs#reasonRepost",
                    "by": {
                        "did": "did:plc:etdcb47v54mwv2wdufhi4tu6",
                        "handle": "osmote.net",
                        "displayName": "OSMOTE",
                        "avatar": "https://cdn.bsky.app/img/avatar/plain/did:plc:etdcb47v54mwv2wdufhi4tu6/bafkreigyn3j5dusyiijtpvqvehcpcb3fbflz5vnggsmq23rw22mgtq7fha@jpeg",
                        "viewer": {
                            "muted": false,
                            "blockedBy": false
                        },
                        "labels": []
                    },
                    "indexedAt": "2024-01-21T16:04:11.253Z"
                }
            }],
            "cursor": "1705710317346::bafyreienbpv65nbuypqeofqfdjmyxf4ijszncp6clavdekjyamhnn2jl4u"
        }
        """#.data(using: .utf8)!
        
        let getAuthorFeedResponsebody = try JSONDecoder().decode(BlueskyGetAuthorFeedResponseBody.self, from: authorFeedJSONData)
        

//        let blueskyClient = BlueskyClient()
//
//        let getAuthorFeedResponse = try await blueskyClient.getAuthorFeed(host: URL(string: "https://bsky.social")!,
//                                                                          accessToken: "eyJhbGciOiJFUzI1NksifQ.eyJzY29wZSI6ImNvbS5hdHByb3RvLmFjY2VzcyIsInN1YiI6ImRpZDpwbGM6ZXRkY2I0N3Y1NG13djJ3ZHVmaGk0dHU2IiwiaWF0IjoxNzA1ODkzOTM5LCJleHAiOjE3MDU5MDExMzksImF1ZCI6ImRpZDp3ZWI6ZW5va2kudXMtZWFzdC5ob3N0LmJza3kubmV0d29yayJ9.NSZwJt-VfmLPZoAlEZ_ZANqnvkIR-MVa77NLoCh2FO5O_ESFG0TaGgiesOmpwUPqALbP9gWoeGbujgT0va4RSA",
//                                                                          refreshToken: "eyJhbGciOiJFUzI1NksifQ.eyJzY29wZSI6ImNvbS5hdHByb3RvLnJlZnJlc2giLCJzdWIiOiJkaWQ6cGxjOmV0ZGNiNDd2NTRtd3Yyd2R1ZmhpNHR1NiIsImF1ZCI6ImRpZDp3ZWI6YnNreS5zb2NpYWwiLCJqdGkiOiJiZEF6dWpyOXF6dXZSekx5UHVkMEdDRHVhdW9mblpPYzFwdkxldGw5L1BRIiwiaWF0IjoxNzA1ODkzOTM5LCJleHAiOjE3MTM2Njk5Mzl9.wQOjV89tDF1L-Cxp9sZX3gPJdERU6_Z6Rvc9boE5WKgvUnHoKk8Tz-BV6zJ9AwRzh3jKs2ThTqWP0I_dudkrDQ",
//                                                                          actor: "osmote.net",
//                                                                          limit: 50,
//                                                                          cursor: "")
//
//        switch getAuthorFeedResponse {
//        case .success(let getAuthorFeedResponseValue):
//            break
//
//        case .failure(let error):
//            break
//        }
    }

    @available(iOS 16.0, *)
    func testRefreshSession() async throws {
        let blueskyClient = BlueskyClient()
        
        let refreshSessionResponse = try await blueskyClient.refreshSession(host: URL(string: "")!, refreshToken: "")

        switch refreshSessionResponse {
        case .success(let refreshSessionResponseValue):
            break

        case .failure(_):
            break
        }
    }
}
