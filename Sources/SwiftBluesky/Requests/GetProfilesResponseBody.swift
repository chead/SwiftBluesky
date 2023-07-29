//
//  GetProfilesResponseBody.swift
//  
//
//  Created by Christopher Head on 7/28/23.
//

import Foundation

public struct GetProfilesResponseBody: Decodable {
    public let profiles: [BlueskyProfile]
}
