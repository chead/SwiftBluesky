//
//  File.swift
//  
//
//  Created by Christopher Head on 9/17/24.
//

import Foundation
import SwiftATProto

public struct BlueskyEmbedVideoView: Decodable {
    public let cid: String
    public let playlist: String
    public let thumbnail: String?
    public let alt: String?
    public let aspectRatio: BlueskyEmbedAspectRatio?
}

public struct BlueskyEmbedVideoCaption: Decodable {
    public let lang: String
    public let file: ATProtoBlob
}

public struct BlueskyEmbedVideo: Decodable {
    public let video: ATProtoBlob
    public let captions: [BlueskyEmbedVideoCaption]?
    public let alt: String?
    public let aspectRatio: BlueskyEmbedAspectRatio?
}
