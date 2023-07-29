//
//  CreateSessionResponseBody.swift
//  
//
//  Created by Christopher Head on 7/28/23.
//

import Foundation

public struct CreateSessionResponseBody: Decodable {
    public let did: String
    public let handle: String
    public let accessJwt: String
    public let refreshJwt: String
}
