//
//  BlueskyFeedGetPostsResponseBody.swift
//
//
//  Created by Christopher Head on 2/1/24.
//

import Foundation

public struct BlueskyFeedGetPostsResponseBody: Decodable {
    public let posts: [BlueskyFeedPostView]
}
