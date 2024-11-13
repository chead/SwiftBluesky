//
//  Repo.swift
//  SwiftBluesky
//
//  Created by Christopher Head on 11/10/24.
//

public extension ATProto {
    final class Repo {
        public struct CommitMeta: Decodable {
            public let cid: String
            public let rev: String
        }
    }
}
