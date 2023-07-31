//
//  BlueskyEmbedImages.swift
//  
//
//  Created by Christopher Head on 7/30/23.
//

import Foundation

public struct BlueskyEmbedImagesImageImageBlobRef: Decodable {
    private enum CodingKeys: String, CodingKey {
        case link = "$link"
    }
    
    let link: String
}

public struct BlueskyEmbedImagesImageImageBlob: Decodable {
    let ref: BlueskyEmbedImagesImageImageBlobRef
    let mimeType: String
    let size: Int
    
}

public enum BlueskyEmbedImagesImageImageType: Decodable {
    private enum FieldType: String, Decodable {
        case blueskyEmbedImagesImageImageBlob = "blob"
    }
    
    private enum CodingKeys: String, CodingKey {
        case type = "$type"
    }

    case blueskyEmbedImagesImageImageBlob(BlueskyEmbedImagesImageImageBlob)
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let fieldType = try container.decode(FieldType.self, forKey: .type)
        
        let singleValueContainer = try decoder.singleValueContainer()
        
        switch fieldType {
        case .blueskyEmbedImagesImageImageBlob:
            try self = .blueskyEmbedImagesImageImageBlob(singleValueContainer.decode(BlueskyEmbedImagesImageImageBlob.self))
        }
    }
}

public struct BlueskyEmbedImagesImage: Decodable {
    public let image: BlueskyEmbedImagesImageImageType
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
