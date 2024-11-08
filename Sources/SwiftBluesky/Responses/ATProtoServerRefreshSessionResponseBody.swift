//
//  ATProtoServerRefreshSessionResponseBody.swift
//  
//
//  Created by Christopher Head on 7/29/23.
//

public struct ATProtoServerRefreshSessionResponseBody: Decodable {
    public let did: String
    public let handle: String
    public let accessJwt: String
    public let refreshJwt: String
}
