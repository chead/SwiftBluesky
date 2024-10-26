//
//  BlueskyFeedGetAuthorFeedResponseBody.swift
//  
//
//  Created by Christopher Head on 7/29/23.
//

import Foundation

public struct BlueskyFeedGetAuthorFeedResponseBody: Decodable {
    public let feed: [BlueskyFeedFeedViewPost]
}
