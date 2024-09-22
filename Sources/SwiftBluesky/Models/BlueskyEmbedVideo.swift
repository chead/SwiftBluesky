//
//  File.swift
//  
//
//  Created by Christopher Head on 9/17/24.
//

import Foundation
import SwiftATProto

public struct BlueskyEmbedVideoView: Decodable {
    let cid: String
    let playlist: String
    let thumbnail: String?
    let alt: String?
    let aspectRatio: BlueskyEmbedAspectRatio?
}

public struct BlueskyEmbedVideoCaption: Decodable {
    let lang: String
    let file: ATProtoBlob
}

public struct BlueskyEmbedVideo: Decodable {
    let video: ATProtoBlob
    let captions: [BlueskyEmbedVideoCaption]?
    let alt: String?
    let aspectRatio: BlueskyEmbedAspectRatio?
}
