//
//  BlueskyEmbedExternal.swift
//  
//
//  Created by Christopher Head on 7/30/23.
//

import Foundation

public struct BlueskyEmbedExternalViewExternal: Decodable {
    let uri: String
    let title: String
    let description: String
    let thumb: String?
}

public struct BlueskyEmbedExternalView: Decodable {
    let external: BlueskyEmbedExternalViewExternal
}

public struct BlueskyEmbedExternalExternal: Decodable {
    let uri: String
    let title: String
    let description: String
    let thumb: String?
}

public struct BlueskyEmbedExternal: Decodable {
    let external: BlueskyEmbedExternalExternal
}
