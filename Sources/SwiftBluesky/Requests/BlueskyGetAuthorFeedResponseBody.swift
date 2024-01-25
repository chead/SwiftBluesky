//
//  BlueskyGetAuthorFeedResponseBody.swift
//  
//
//  Created by Christopher Head on 7/29/23.
//

import Foundation

public struct BlueskyGetAuthorFeedResponseBody: Decodable {
    public let feed: [BlueskyFeedFeedViewPost]
}
