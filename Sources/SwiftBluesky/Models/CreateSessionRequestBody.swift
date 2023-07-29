//
//  CreateSessionRequestBody.swift
//  
//
//  Created by Christopher Head on 7/28/23.
//

import Foundation

public struct CreateSessionRequestBody: Encodable {
    public let identifier: String
    public let password: String
}
