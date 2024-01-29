//
//  BlueskyEmbedImage.swift
//
//
//  Created by Christopher Head on 1/24/24.
//

import Foundation
import SwiftATProto


public struct BlueskyEmbedImagesAspectRatio: Decodable {
    private enum CodingKeys: CodingKey {
        case width
        case height
    }

    public let width: Int
    public let height: Int

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let width = try container.decode(Int.self, forKey: .width)

        guard width > 1 else {
            throw DecodingError.dataCorrupted(.init(codingPath: decoder.codingPath, debugDescription: "Invalid width."))
        }

        self.width = width

        let height = try container.decode(Int.self, forKey: .height)

        guard height > 1 else {
            throw DecodingError.dataCorrupted(.init(codingPath: decoder.codingPath, debugDescription: "Invalid height."))
        }

        self.height = height
    }
}

public struct BlueskyEmbedImagesViewImage: Decodable {
    public let thumb: String
    public let fullsize: String
    public let alt: String
    public let aspectRatio: BlueskyEmbedImagesAspectRatio?
}

public struct BlueskyEmbedImagesView: Decodable {
    private enum CodingKeys: CodingKey {
        case images
    }

    public let images: [BlueskyEmbedImagesViewImage]

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let images = try container.decode([BlueskyEmbedImagesViewImage].self, forKey: .images)

        guard images.count <= 4 else {
            throw DecodingError.dataCorrupted(.init(codingPath: decoder.codingPath, debugDescription: "Too many images."))
        }

        self.images = images
    }
}

public enum BlueskyEmbedImagesImageType: Decodable {
    case atProtoBlob(ATProtoBlob)
    case atProtoImageBlob(ATProtoImageBlob)

    public init(from decoder: Decoder) throws {
        let singleValueContainer = try decoder.singleValueContainer()

        if let atProtoBlob = try? singleValueContainer.decode(ATProtoBlob.self) {
            self = .atProtoBlob(atProtoBlob)
        } 
        else if let atProtoImageBlob = try? singleValueContainer.decode(ATProtoImageBlob.self) {
            self = .atProtoImageBlob(atProtoImageBlob)
        } 
        else {
            throw DecodingError.dataCorrupted(.init(codingPath: decoder.codingPath, debugDescription: "No blob found."))
        }
    }
}

public struct BlueskyEmbedImagesImage: Decodable {
    public let image: BlueskyEmbedImagesImageType
    public let alt: String
    public let aspectRatio: BlueskyEmbedImagesAspectRatio?
}

public struct BlueskyEmbedImages: Decodable {
    private enum CodingKeys: CodingKey {
        case images
    }

    public let images: [BlueskyEmbedImagesImage]

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let images = try container.decode([BlueskyEmbedImagesImage].self, forKey: .images)

        guard images.count <= 4 else {
            throw DecodingError.dataCorrupted(.init(codingPath: decoder.codingPath, debugDescription: "Too many images."))
        }

        self.images = images
    }
}
