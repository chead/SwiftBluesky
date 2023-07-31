//
//  BlueskyEmbedImages.swift
//  
//
//  Created by Christopher Head on 7/30/23.
//

import Foundation

public struct BlueskyEmbedImagesImage: Decodable {
    public let image: String
    public let alt: String
}

public struct BlueskyEmbedImagesViewImage: Decodable {
    public let thumb: String
    public let fullsize: String
    public let alt: String
}

public struct BlueskyEmbedImagesView: Decodable {
    public let images: [BlueskyEmbedImagesViewImage]  // FIXME: Max length = 4
}

public struct BlueskyEmbedImages: Decodable {
    public let images: [BlueskyEmbedImagesImage] // FIXME: Max length = 4
}
