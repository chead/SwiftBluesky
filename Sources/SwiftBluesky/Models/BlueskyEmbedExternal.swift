//
//  BlueskyEmbedExternal.swift
//
//
//  Created by Christopher Head on 1/23/24.
//

import Foundation
import SwiftATProto

public struct BlueskyEmbedExternalViewExternal: Decodable {
    public let uri: String
    public let description: String
    public let thumb: String?
}

public struct BlueskyEmbedExternalView: Decodable {
    public let external: BlueskyEmbedExternalViewExternal
}

public struct BlueskyEmbedExternalExternal: Decodable {
    public let uri: String
    public let title: String
    public let description: String
    public let thumb: ATProtoBlob?
}

public struct BlueskyEmbedExternal: Decodable {
    public let external: BlueskyEmbedExternalExternal
}
