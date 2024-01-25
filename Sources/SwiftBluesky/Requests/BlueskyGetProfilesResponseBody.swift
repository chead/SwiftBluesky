//
//  BlueskyGetProfilesResponseBody.swift
//  
//
//  Created by Christopher Head on 7/28/23.
//

import Foundation

public struct BlueskyGetProfilesResponseBody: Decodable {
    public let profiles: [BlueskyActorProfileViewDetailed]
}
