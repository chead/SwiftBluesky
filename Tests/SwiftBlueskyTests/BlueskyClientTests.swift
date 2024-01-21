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
                    "uri": "at://did:plc:katl2n3xfpfwpv45aiwwtbrb/app.bsky.feed.post/3k3qugjur6l2k",
                    "cid": "bafyreie5tzr2hj2vqml6lqise3efcnf4kbq3n3da5upaelpywdlzas7tx4",
                    "author": {
                        "did": "did:plc:katl2n3xfpfwpv45aiwwtbrb",
                        "handle": "cara.city",
                        "displayName": "Cara Esten",
                        "avatar": "https://cdn.bsky.social/imgproxy/JHVRMZMxsKsD2wVzuTlW3pHooBwu_wYJ05E18C5lMSM/rs:fill:1000:1000:1:0/plain/bafkreicdwsx7drxkrkxfeqqom3roholmph3ucawk5gzvncpdva7pwv2cle@jpeg",
                        "viewer": {
                            "muted": false,
                            "blockedBy": false,
                            "following": "at://did:plc:etdcb47v54mwv2wdufhi4tu6/app.bsky.graph.follow/3jwgqjr25tt2e"
                        },
                        "labels": []
                    },
                    "record": {
                        "text": "the main way people were introduced to software or computing as a whole was through work, meaning the process was both inherently forced and deeply alienating, and this is still true about software today",
                        "$type": "app.bsky.feed.post",
                        "langs": ["en"],
                        "reply": {
                            "root": {
                                "cid": "bafyreigf6grw6z6yeclddjqhnixstrlq5y7x4smbllvl4e5t56ggsrrl7e",
                                "uri": "at://did:plc:katl2n3xfpfwpv45aiwwtbrb/app.bsky.feed.post/3k3quav3yrz2z"
                            },
                            "parent": {
                                "cid": "bafyreigf6grw6z6yeclddjqhnixstrlq5y7x4smbllvl4e5t56ggsrrl7e",
                                "uri": "at://did:plc:katl2n3xfpfwpv45aiwwtbrb/app.bsky.feed.post/3k3quav3yrz2z"
                            }
                        },
                        "createdAt": "2023-07-30T16:13:42.191Z"
                    },
                    "replyCount": 7,
                    "repostCount": 2,
                    "likeCount": 46,
                    "indexedAt": "2023-07-30T16:13:42.701Z",
                    "viewer": {
                        "repost": "at://did:plc:etdcb47v54mwv2wdufhi4tu6/app.bsky.feed.repost/3k3rcfq3hnm25",
                        "like": "at://did:plc:etdcb47v54mwv2wdufhi4tu6/app.bsky.feed.like/3k3rcfjgbjn2g"
                    },
                    "labels": []
                },
                "reason": {
                    "$type": "app.bsky.feed.defs#reasonRepost",
                    "by": {
                        "did": "did:plc:etdcb47v54mwv2wdufhi4tu6",
                        "handle": "osmote.net",
                        "displayName": "OSMOTE",
                        "avatar": "https://cdn.bsky.social/imgproxy/RBZIac2OfcH-vYiDZZbglv00yjvIqzNbDXu_FX5tMoM/rs:fill:1000:1000:1:0/plain/bafkreigyn3j5dusyiijtpvqvehcpcb3fbflz5vnggsmq23rw22mgtq7fha@jpeg",
                        "viewer": {
                            "muted": false,
                            "blockedBy": false
                        },
                        "labels": []
                    },
                    "indexedAt": "2023-07-30T20:23:47.880Z"
                },
                "reply": {
                    "root": {
                        "$type": "app.bsky.feed.defs#postView",
                        "uri": "at://did:plc:katl2n3xfpfwpv45aiwwtbrb/app.bsky.feed.post/3k3quav3yrz2z",
                        "cid": "bafyreigf6grw6z6yeclddjqhnixstrlq5y7x4smbllvl4e5t56ggsrrl7e",
                        "author": {
                            "did": "did:plc:katl2n3xfpfwpv45aiwwtbrb",
                            "handle": "cara.city",
                            "displayName": "Cara Esten",
                            "avatar": "https://cdn.bsky.social/imgproxy/JHVRMZMxsKsD2wVzuTlW3pHooBwu_wYJ05E18C5lMSM/rs:fill:1000:1000:1:0/plain/bafkreicdwsx7drxkrkxfeqqom3roholmph3ucawk5gzvncpdva7pwv2cle@jpeg",
                            "viewer": {
                                "muted": false,
                                "blockedBy": false,
                                "following": "at://did:plc:etdcb47v54mwv2wdufhi4tu6/app.bsky.graph.follow/3jwgqjr25tt2e"
                            },
                            "labels": []
                        },
                        "record": {
                            "text": "it's easy to forget that people actively hated computers until the mid 90s and honestly were right to do so",
                            "$type": "app.bsky.feed.post",
                            "embed": {
                                "$type": "app.bsky.embed.images",
                                "images": [{
                                    "alt": "A book open to page 194, chapter 6, the text:\n\ning Computer Fear and Technostress, both published in 1984, indicates that \"for many people, computers were extremely unpleasant objects and their introduction into some people's lives caused extreme duress.\" However prevalent among hobbyists and futurists, discourses about the home computer revolution were largely lost on the broader American public.",
                                    "image": {
                                        "$type": "blob",
                                        "ref": {
                                            "$link": "bafkreigorl6ng46ks6zyyfokf4ol254yzqwmorhsapdlvocqv4j3q26qge"
                                        },
                                        "mimeType": "image/jpeg",
                                        "size": 555818
                                    }
                                }]
                            },
                            "langs": ["en"],
                            "createdAt": "2023-07-30T16:10:32.665Z"
                        },
                        "embed": {
                            "$type": "app.bsky.embed.images#view",
                            "images": [{
                                "thumb": "https://cdn.bsky.social/imgproxy/A2WhjFDtzPhNljSEqhF8tzhLE-tvjDNDR2NGIUnfYrg/rs:fit:1000:1000:1:0/plain/bafkreigorl6ng46ks6zyyfokf4ol254yzqwmorhsapdlvocqv4j3q26qge@jpeg",
                                "fullsize": "https://cdn.bsky.social/imgproxy/h_g3R7CMWFeavdG9DWFncllqnMHHyacjyBNcdTeUE80/rs:fit:2000:2000:1:0/plain/bafkreigorl6ng46ks6zyyfokf4ol254yzqwmorhsapdlvocqv4j3q26qge@jpeg",
                                "alt": "A book open to page 194, chapter 6, the text:\n\ning Computer Fear and Technostress, both published in 1984, indicates that \"for many people, computers were extremely unpleasant objects and their introduction into some people's lives caused extreme duress.\" However prevalent among hobbyists and futurists, discourses about the home computer revolution were largely lost on the broader American public."
                            }]
                        },
                        "replyCount": 8,
                        "repostCount": 9,
                        "likeCount": 93,
                        "indexedAt": "2023-07-30T16:10:33.154Z",
                        "viewer": {
                            "like": "at://did:plc:etdcb47v54mwv2wdufhi4tu6/app.bsky.feed.like/3k3rcfmd3mu2c"
                        },
                        "labels": []
                    },
                    "parent": {
                        "$type": "app.bsky.feed.defs#postView",
                        "uri": "at://did:plc:katl2n3xfpfwpv45aiwwtbrb/app.bsky.feed.post/3k3quav3yrz2z",
                        "cid": "bafyreigf6grw6z6yeclddjqhnixstrlq5y7x4smbllvl4e5t56ggsrrl7e",
                        "author": {
                            "did": "did:plc:katl2n3xfpfwpv45aiwwtbrb",
                            "handle": "cara.city",
                            "displayName": "Cara Esten",
                            "avatar": "https://cdn.bsky.social/imgproxy/JHVRMZMxsKsD2wVzuTlW3pHooBwu_wYJ05E18C5lMSM/rs:fill:1000:1000:1:0/plain/bafkreicdwsx7drxkrkxfeqqom3roholmph3ucawk5gzvncpdva7pwv2cle@jpeg",
                            "viewer": {
                                "muted": false,
                                "blockedBy": false,
                                "following": "at://did:plc:etdcb47v54mwv2wdufhi4tu6/app.bsky.graph.follow/3jwgqjr25tt2e"
                            },
                            "labels": []
                        },
                        "record": {
                            "text": "it's easy to forget that people actively hated computers until the mid 90s and honestly were right to do so",
                            "$type": "app.bsky.feed.post",
                            "embed": {
                                "$type": "app.bsky.embed.images",
                                "images": [{
                                    "alt": "A book open to page 194, chapter 6, the text:\n\ning Computer Fear and Technostress, both published in 1984, indicates that \"for many people, computers were extremely unpleasant objects and their introduction into some people's lives caused extreme duress.\" However prevalent among hobbyists and futurists, discourses about the home computer revolution were largely lost on the broader American public.",
                                    "image": {
                                        "$type": "blob",
                                        "ref": {
                                            "$link": "bafkreigorl6ng46ks6zyyfokf4ol254yzqwmorhsapdlvocqv4j3q26qge"
                                        },
                                        "mimeType": "image/jpeg",
                                        "size": 555818
                                    }
                                }]
                            },
                            "langs": ["en"],
                            "createdAt": "2023-07-30T16:10:32.665Z"
                        },
                        "embed": {
                            "$type": "app.bsky.embed.images#view",
                            "images": [{
                                "thumb": "https://cdn.bsky.social/imgproxy/A2WhjFDtzPhNljSEqhF8tzhLE-tvjDNDR2NGIUnfYrg/rs:fit:1000:1000:1:0/plain/bafkreigorl6ng46ks6zyyfokf4ol254yzqwmorhsapdlvocqv4j3q26qge@jpeg",
                                "fullsize": "https://cdn.bsky.social/imgproxy/h_g3R7CMWFeavdG9DWFncllqnMHHyacjyBNcdTeUE80/rs:fit:2000:2000:1:0/plain/bafkreigorl6ng46ks6zyyfokf4ol254yzqwmorhsapdlvocqv4j3q26qge@jpeg",
                                "alt": "A book open to page 194, chapter 6, the text:\n\ning Computer Fear and Technostress, both published in 1984, indicates that \"for many people, computers were extremely unpleasant objects and their introduction into some people's lives caused extreme duress.\" However prevalent among hobbyists and futurists, discourses about the home computer revolution were largely lost on the broader American public."
                            }]
                        },
                        "replyCount": 8,
                        "repostCount": 9,
                        "likeCount": 93,
                        "indexedAt": "2023-07-30T16:10:33.154Z",
                        "viewer": {
                            "like": "at://did:plc:etdcb47v54mwv2wdufhi4tu6/app.bsky.feed.like/3k3rcfmd3mu2c"
                        },
                        "labels": []
                    }
                }
            }, {
                "post": {
                    "uri": "at://did:plc:etdcb47v54mwv2wdufhi4tu6/app.bsky.feed.post/3k3r7myqqzo2z",
                    "cid": "bafyreiayqma55bb66p2xzuslxsh4e2d35qjks5vbmv3cidbmnu5wyj65py",
                    "author": {
                        "did": "did:plc:etdcb47v54mwv2wdufhi4tu6",
                        "handle": "osmote.net",
                        "displayName": "OSMOTE",
                        "avatar": "https://cdn.bsky.social/imgproxy/RBZIac2OfcH-vYiDZZbglv00yjvIqzNbDXu_FX5tMoM/rs:fill:1000:1000:1:0/plain/bafkreigyn3j5dusyiijtpvqvehcpcb3fbflz5vnggsmq23rw22mgtq7fha@jpeg",
                        "viewer": {
                            "muted": false,
                            "blockedBy": false
                        },
                        "labels": []
                    },
                    "record": {
                        "text": "Test Two",
                        "$type": "app.bsky.feed.post",
                        "embed": {
                            "$type": "app.bsky.embed.record",
                            "record": {
                                "cid": "bafyreignshupwvhurhh6ytxiirktho6hbxq5z4otspteycndgo7uc5ehcy",
                                "uri": "at://did:plc:etdcb47v54mwv2wdufhi4tu6/app.bsky.feed.post/3k3r7mrdhvc2c"
                            }
                        },
                        "langs": ["en"],
                        "createdAt": "2023-07-30T19:34:10.911Z"
                    },
                    "embed": {
                        "$type": "app.bsky.embed.record#view",
                        "record": {
                            "$type": "app.bsky.embed.record#viewRecord",
                            "uri": "at://did:plc:etdcb47v54mwv2wdufhi4tu6/app.bsky.feed.post/3k3r7mrdhvc2c",
                            "cid": "bafyreignshupwvhurhh6ytxiirktho6hbxq5z4otspteycndgo7uc5ehcy",
                            "author": {
                                "did": "did:plc:etdcb47v54mwv2wdufhi4tu6",
                                "handle": "osmote.net",
                                "displayName": "OSMOTE",
                                "avatar": "https://cdn.bsky.social/imgproxy/RBZIac2OfcH-vYiDZZbglv00yjvIqzNbDXu_FX5tMoM/rs:fill:1000:1000:1:0/plain/bafkreigyn3j5dusyiijtpvqvehcpcb3fbflz5vnggsmq23rw22mgtq7fha@jpeg",
                                "viewer": {
                                    "muted": false,
                                    "blockedBy": false
                                },
                                "labels": []
                            },
                            "value": {
                                "text": "Test One",
                                "$type": "app.bsky.feed.post",
                                "langs": ["en"],
                                "createdAt": "2023-07-30T19:34:03.137Z"
                            },
                            "labels": [],
                            "indexedAt": "2023-07-30T19:34:03.131Z",
                            "embeds": []
                        }
                    },
                    "replyCount": 0,
                    "repostCount": 0,
                    "likeCount": 0,
                    "indexedAt": "2023-07-30T19:34:10.809Z",
                    "viewer": {},
                    "labels": []
                }
            }, {
                "post": {
                    "uri": "at://did:plc:etdcb47v54mwv2wdufhi4tu6/app.bsky.feed.post/3k3r7mrdhvc2c",
                    "cid": "bafyreignshupwvhurhh6ytxiirktho6hbxq5z4otspteycndgo7uc5ehcy",
                    "author": {
                        "did": "did:plc:etdcb47v54mwv2wdufhi4tu6",
                        "handle": "osmote.net",
                        "displayName": "OSMOTE",
                        "avatar": "https://cdn.bsky.social/imgproxy/RBZIac2OfcH-vYiDZZbglv00yjvIqzNbDXu_FX5tMoM/rs:fill:1000:1000:1:0/plain/bafkreigyn3j5dusyiijtpvqvehcpcb3fbflz5vnggsmq23rw22mgtq7fha@jpeg",
                        "viewer": {
                            "muted": false,
                            "blockedBy": false
                        },
                        "labels": []
                    },
                    "record": {
                        "text": "Test One",
                        "$type": "app.bsky.feed.post",
                        "langs": ["en"],
                        "createdAt": "2023-07-30T19:34:03.137Z"
                    },
                    "replyCount": 0,
                    "repostCount": 0,
                    "likeCount": 0,
                    "indexedAt": "2023-07-30T19:34:03.131Z",
                    "viewer": {},
                    "labels": []
                }
            }, {
                "post": {
                    "uri": "at://did:plc:etdcb47v54mwv2wdufhi4tu6/app.bsky.feed.post/3k3qyqku4bq2u",
                    "cid": "bafyreihbxjyipara5dssrghzvycsg36qsknnix7d3dzhhsh2euqurxwecy",
                    "author": {
                        "did": "did:plc:etdcb47v54mwv2wdufhi4tu6",
                        "handle": "osmote.net",
                        "displayName": "OSMOTE",
                        "avatar": "https://cdn.bsky.social/imgproxy/RBZIac2OfcH-vYiDZZbglv00yjvIqzNbDXu_FX5tMoM/rs:fill:1000:1000:1:0/plain/bafkreigyn3j5dusyiijtpvqvehcpcb3fbflz5vnggsmq23rw22mgtq7fha@jpeg",
                        "viewer": {
                            "muted": false,
                            "blockedBy": false
                        },
                        "labels": []
                    },
                    "record": {
                        "text": "get out",
                        "$type": "app.bsky.feed.post",
                        "langs": ["en"],
                        "reply": {
                            "root": {
                                "cid": "bafyreih2z2mijaliovyjhggyktwci4chenlvclrp2riy2ikwmsvquner4q",
                                "uri": "at://did:plc:53kudcqj7sizx2eaclc5sicc/app.bsky.feed.post/3k3qwrbkblx2c"
                            },
                            "parent": {
                                "cid": "bafyreibt3jtvss7anixhjdh72qp7jkqcjcohmmvzzg5oxybmrzwghsvoti",
                                "uri": "at://did:plc:vpgewixeiml7eg2nxqs77agr/app.bsky.feed.post/3k3qxgzmh272g"
                            }
                        },
                        "createdAt": "2023-07-30T17:30:53.958Z"
                    },
                    "replyCount": 0,
                    "repostCount": 0,
                    "likeCount": 5,
                    "indexedAt": "2023-07-30T17:30:54.255Z",
                    "viewer": {},
                    "labels": []
                },
                "reply": {
                    "root": {
                        "$type": "app.bsky.feed.defs#postView",
                        "uri": "at://did:plc:53kudcqj7sizx2eaclc5sicc/app.bsky.feed.post/3k3qwrbkblx2c",
                        "cid": "bafyreih2z2mijaliovyjhggyktwci4chenlvclrp2riy2ikwmsvquner4q",
                        "author": {
                            "did": "did:plc:53kudcqj7sizx2eaclc5sicc",
                            "handle": "bennie.gay",
                            "displayName": "Bennie Dorothy Gay ",
                            "avatar": "https://cdn.bsky.social/imgproxy/3r02V906meaIgRmt8hCZc3N8WygflRsrAHNoy-edoLk/rs:fill:1000:1000:1:0/plain/bafkreienhkpjaow2wkmtgcsjacqaz5son55nmp3grq2wkpm3eoays7knhq@jpeg",
                            "viewer": {
                                "muted": false,
                                "blockedBy": false
                            },
                            "labels": []
                        },
                        "record": {
                            "text": "Amazing seeing men posting pics that are just as revealing as one of my most recent pics but theirs isn't flagged at all and mine is flagged as \"nudity\" LMAOO",
                            "$type": "app.bsky.feed.post",
                            "langs": ["en"],
                            "createdAt": "2023-07-30T16:55:28.839Z"
                        },
                        "replyCount": 12,
                        "repostCount": 15,
                        "likeCount": 236,
                        "indexedAt": "2023-07-30T16:55:30.668Z",
                        "viewer": {},
                        "labels": []
                    },
                    "parent": {
                        "$type": "app.bsky.feed.defs#postView",
                        "uri": "at://did:plc:vpgewixeiml7eg2nxqs77agr/app.bsky.feed.post/3k3qxgzmh272g",
                        "cid": "bafyreibt3jtvss7anixhjdh72qp7jkqcjcohmmvzzg5oxybmrzwghsvoti",
                        "author": {
                            "did": "did:plc:vpgewixeiml7eg2nxqs77agr",
                            "handle": "jennscarlet.bsky.social",
                            "displayName": "Jenn Scarlet ",
                            "avatar": "https://cdn.bsky.social/imgproxy/Fei-E9jmU4S56HQkzSFGxMrofUdUIh_sZVVglFIDGd0/rs:fill:1000:1000:1:0/plain/bafkreicc4ekwof6txvx5cum235r5a2a4ux3z2baeqyjmzwdqckupul3q5a@jpeg",
                            "viewer": {
                                "muted": false,
                                "blockedBy": false
                            },
                            "labels": []
                        },
                        "record": {
                            "text": "Don't know who you are but stop posting porn on not Twitter. Class it up.",
                            "$type": "app.bsky.feed.post",
                            "langs": ["en"],
                            "reply": {
                                "root": {
                                    "cid": "bafyreih2z2mijaliovyjhggyktwci4chenlvclrp2riy2ikwmsvquner4q",
                                    "uri": "at://did:plc:53kudcqj7sizx2eaclc5sicc/app.bsky.feed.post/3k3qwrbkblx2c"
                                },
                                "parent": {
                                    "cid": "bafyreih2z2mijaliovyjhggyktwci4chenlvclrp2riy2ikwmsvquner4q",
                                    "uri": "at://did:plc:53kudcqj7sizx2eaclc5sicc/app.bsky.feed.post/3k3qwrbkblx2c"
                                }
                            },
                            "createdAt": "2023-07-30T17:07:40.826Z"
                        },
                        "replyCount": 129,
                        "repostCount": 0,
                        "likeCount": 8,
                        "indexedAt": "2023-07-30T17:07:40.419Z",
                        "viewer": {},
                        "labels": []
                    }
                }
            }, {
                "post": {
                    "uri": "at://did:plc:etdcb47v54mwv2wdufhi4tu6/app.bsky.feed.post/3k3qym3dygx2g",
                    "cid": "bafyreibj5vh7kfqzttdqkwnjsvs5drq5q3ugldodoaqxkv56jaeex6rkhy",
                    "author": {
                        "did": "did:plc:etdcb47v54mwv2wdufhi4tu6",
                        "handle": "osmote.net",
                        "displayName": "OSMOTE",
                        "avatar": "https://cdn.bsky.social/imgproxy/RBZIac2OfcH-vYiDZZbglv00yjvIqzNbDXu_FX5tMoM/rs:fill:1000:1000:1:0/plain/bafkreigyn3j5dusyiijtpvqvehcpcb3fbflz5vnggsmq23rw22mgtq7fha@jpeg",
                        "viewer": {
                            "muted": false,
                            "blockedBy": false
                        },
                        "labels": []
                    },
                    "record": {
                        "text": "how would you explain phone prank comedy tapes to a zoomer",
                        "$type": "app.bsky.feed.post",
                        "langs": ["en"],
                        "createdAt": "2023-07-30T17:28:23.473Z"
                    },
                    "replyCount": 0,
                    "repostCount": 0,
                    "likeCount": 1,
                    "indexedAt": "2023-07-30T17:28:23.815Z",
                    "viewer": {},
                    "labels": []
                }
            }],
            "cursor": "1690738103473::bafyreibj5vh7kfqzttdqkwnjsvs5drq5q3ugldodoaqxkv56jaeex6rkhy"
        }
        """#.data(using: .utf8)!
        
        let getAuthorFeedResponsebody = try JSONDecoder().decode(GetAuthorFeedResponseBody.self, from: authorFeedJSONData)
        
        let blueskyClient = BlueskyClient()

        let getAuthorFeedResponse = try await blueskyClient.getAuthorFeed(host: URL(string: "https://bsky.social")!,
                                                                          accessToken: "eyJhbGciOiJFUzI1NksifQ.eyJzY29wZSI6ImNvbS5hdHByb3RvLmFjY2VzcyIsInN1YiI6ImRpZDpwbGM6ZXRkY2I0N3Y1NG13djJ3ZHVmaGk0dHU2IiwiaWF0IjoxNzA1NzkzNjUzLCJleHAiOjE3MDU4MDA4NTMsImF1ZCI6ImRpZDp3ZWI6ZW5va2kudXMtZWFzdC5ob3N0LmJza3kubmV0d29yayJ9.xp1qfD0k7d3dO-yKvVGanLgrT8am8Dq5J8Y9L1qbm7twRGDrXrWUAnGaIf6B3mP8eoA99O7B_CF-pHOA3aCKsA",
                                                                          refreshToken: "eyJhbGciOiJFUzI1NksifQ.eyJzY29wZSI6ImNvbS5hdHByb3RvLnJlZnJlc2giLCJzdWIiOiJkaWQ6cGxjOmV0ZGNiNDd2NTRtd3Yyd2R1ZmhpNHR1NiIsImF1ZCI6ImRpZDp3ZWI6YnNreS5zb2NpYWwiLCJqdGkiOiI0WkFkTkt0aTduVDd2NnoxSjZiYTdPNTc2QnNvd2kwNFIwOXpjVE1CenFJIiwiaWF0IjoxNzA1NzkzNjUzLCJleHAiOjE3MTM1Njk2NTN9.8TFex_ezD52MaTEGAYTwCb9wlA0TrQHziwJBHIoRnAODGQEKAapE_UKA89VcOHen85SJFMu_QEILZ9dLRpq7mg",
                                                                          actor: "osmote.net",
                                                                          limit: 5,
                                                                          cursor: "")

        switch getAuthorFeedResponse {
        case .success(let getAuthorFeedResponseValue):
            break

        case .failure(let error):
            break
        }
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
