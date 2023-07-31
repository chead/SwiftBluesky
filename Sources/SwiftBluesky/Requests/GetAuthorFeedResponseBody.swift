//
//  GetAuthorFeedResponseBody.swift
//  
//
//  Created by Christopher Head on 7/29/23.
//

import Foundation

public struct GetAuthorFeedResponseBody: Decodable {
    let feed: [BlueskyFeedFeedViewPost]
}
