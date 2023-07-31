//
//  BlueskyRichtextFacet.swift
//  
//
//  Created by Christopher Head on 7/30/23.
//

import Foundation

public struct BlueskyRichtextFacetMention: Decodable {
    public let did: String
}

public struct BlueskyRichtextFacetLink: Decodable {
    public let uri: String
}

public struct BlueskyRichtextFacetByteSlice: Decodable {
    public let byteStart: Int
    public let byteEnd: Int
}

public enum BlueskyRichtextFacetFeaturesType: Decodable {
    private enum FieldType: String, Decodable {
        case blueskyRichtextFacetMention = "#mention"
        case blueskyRichtextFacetLink = "#link"
    }
    
    private enum CodingKeys: String, CodingKey {
        case type = "$type"
    }
    
    case blueskyRichtextFacetMention(BlueskyRichtextFacetMention)
    case blueskyRichtextFacetLink(BlueskyRichtextFacetLink)

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let fieldType = try container.decode(FieldType.self, forKey: .type)
        
        let singleValueContainer = try decoder.singleValueContainer()
        
        switch fieldType {
        case .blueskyRichtextFacetMention:
            try self = .blueskyRichtextFacetMention(singleValueContainer.decode(BlueskyRichtextFacetMention.self))

        case .blueskyRichtextFacetLink:
            try self = .blueskyRichtextFacetLink(singleValueContainer.decode(BlueskyRichtextFacetLink.self))
        }
    }
}

public struct BlueskyRichtextFacet: Decodable {
    public let index: BlueskyRichtextFacetByteSlice
    
}
