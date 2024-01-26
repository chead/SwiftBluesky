//
//  BlueskyGetTimelineResponseBody.swift
//
//
//  Created by Christopher Head on 1/25/24.
//

import Foundation

public struct BlueskyGetTimelineResponseBody: Decodable {
    let cursor: String
    let feed: [BlueskyFeedFeedViewPost]
}
