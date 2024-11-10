//
//  BlueskyGraphGetListsResponseBody.swift
//  SwiftBluesky
//
//  Created by Christopher Head on 11/9/24.
//

public struct BlueskyGraphGetListsResponseBody: Decodable {
    public let lists: [BlueskyGraphListViewBasic]
}
