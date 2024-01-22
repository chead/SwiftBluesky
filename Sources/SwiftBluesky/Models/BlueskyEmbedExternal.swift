//
//  BlueskyEmbedExternal.swift
//  
//
//  Created by Christopher Head on 7/30/23.
//

import Foundation

public struct BlueskyEmbedEmbedExternalExternalBlobRef: Decodable {
    private enum CodingKeys: String, CodingKey {
        case link = "$link"
    }

    let link: String
}

public struct BlueskyEmbedEmbedExternalExternalBlob: Decodable {
    let ref: BlueskyEmbedEmbedExternalExternalBlobRef
    let mimeType: String
    let size: Int

}

public enum BlueskyEmbedExternalViewExternalThumbType: Decodable {
    private enum FieldType: String, Decodable {
        case blueskyEmbedImagesImageImageBlob = "blob"
    }

    private enum CodingKeys: String, CodingKey {
        case type = "$type"
    }

    case blueskyEmbedEmbedExternalExternalBlob(BlueskyEmbedEmbedExternalExternalBlob)

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let fieldType = try container.decode(FieldType.self, forKey: .type)

        let singleValueContainer = try decoder.singleValueContainer()

        switch fieldType {
        case .blueskyEmbedImagesImageImageBlob:
            try self = .blueskyEmbedEmbedExternalExternalBlob(singleValueContainer.decode(BlueskyEmbedEmbedExternalExternalBlob.self))
        }
    }
}

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
    let thumb: BlueskyEmbedImagesImageImageBlob?
}

public struct BlueskyEmbedExternal: Decodable {
    let external: BlueskyEmbedExternalExternal
}
