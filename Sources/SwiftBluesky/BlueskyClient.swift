//
//  BlueskyClient.swift
//  
//
//  Created by Christopher Head on 7/28/23.
//

import Foundation
import SwiftATProto
import SwiftLexicon

@available(iOS 16.0, *)
public enum BlueskyClientError<MethodError: Decodable>: Error {
    case badRequest(error: ATProtoHTTPClientBadRequestType<MethodError>, message: String)
    case badResponse(error: Error)
    case noResponse
    case unauthorized
    case forbidden
    case notFound
    case largePayload
    case tooManyRequests
    case internalServerError
    case notImplemented
    case unavailable
    case session(error: Error)
    case unknown(status: Int)
    case invalidRequest
    case invalidResponse
    case invalidLexicon

    init(atProtoHTTPClientError: ATProtoHTTPClientError<MethodError>) {
        switch(atProtoHTTPClientError) {
        case .badRequest(let error, let message):
            self = .badRequest(error: error, message: message)

        case .badResponse(let error):
            self = .badResponse(error: error)

        case .noResponse:
            self = .noResponse

        case .unauthorized:
            self = .unauthorized

        case .forbidden:
            self = .forbidden

        case .notFound:
            self = .notFound

        case .largePayload:
            self = .largePayload

        case .tooManyRequests:
            self = .tooManyRequests

        case .internalServerError:
            self = .internalServerError

        case .notImplemented:
            self = .notImplemented

        case .unavailable:
            self = .unavailable

        case .session(let error):
            self = .session(error: error)

        case .unknown(let status):
            self = .unknown(status: status)
        }
    }
}

@available(iOS 16.0, *)
public class BlueskyClient {
    private static func makeRequest<RequestBody: Encodable, ResponseBody: Decodable, MethodError: Decodable>(lexicon: String, host: URL, credentials: (accessToken: String, refreshToken: String)? = nil, body: RequestBody?, parameters: [String : any Encodable], encoding: String? = nil, retry: Bool = true) async throws -> Result<(body: ResponseBody, credentials: (accessToken: String, refreshToken: String)?), BlueskyClientError<MethodError>> {
        let requestLexicon = try JSONDecoder().decode(Lexicon.self, from: try Data(contentsOf: Bundle.module.url(forResource: lexicon, withExtension: "json")!))

        var requestable: (any LexiconHTTPRequestable)?

        if let mainDef = requestLexicon.defs["main"] {
            switch mainDef {
            case .query(let lexiconQuery):
                requestable = lexiconQuery

            case .procedure(let lexiconProcedure):
                requestable = lexiconProcedure

            default:
                return .failure(.invalidRequest)
            }

        } else {
            return .failure(.invalidLexicon)
        }

        guard let requestable = requestable else {
            return .failure(.invalidRequest)
        }

        let request = try ATProtoHTTPRequest(host: host,
                                             nsid: requestLexicon.id,
                                             parameters: parameters,
                                             body: body,
                                             token: credentials?.accessToken,
                                             requestable: requestable,
                                             encoding: encoding)

        let response: Result<ResponseBody, ATProtoHTTPClientError<MethodError>> = await ATProtoHTTPClient.make(request: request)

        switch response {
        case .success(let result):
            return .success((body: result,
                             credentials: retry == false ? credentials : nil))

        case .failure(let error):
            switch(error) {
            case .badRequest(error: let requestError):
                switch(requestError.error) {
                case .request(let blueskyRequestError):
                    switch(blueskyRequestError) {
                    case .expiredToken:
                        if retry, let credentials = credentials {
                            switch(try await Server.refreshSession(host: host,
                                                                   refreshToken: credentials.refreshToken)) {
                            case .success(let refreshSessionResponse):
                                return try await makeRequest(lexicon: lexicon,
                                                             host: host,
                                                             credentials: (refreshSessionResponse.accessJwt,
                                                                           refreshSessionResponse.refreshJwt),
                                                             body: body,
                                                             parameters: parameters,
                                                             retry: false)

                            default:
                                break
                            }
                        }

                        return .failure(BlueskyClientError(atProtoHTTPClientError: error))

                    default:
                        return .failure(BlueskyClientError(atProtoHTTPClientError: error))
                    }

                default:
                    return .failure(BlueskyClientError(atProtoHTTPClientError: error))
                }

            default:
                return .failure(BlueskyClientError(atProtoHTTPClientError: error))
            }
        }
    }

    public struct Server {
        public enum ATProtoCreateSessionError: String, Decodable, Error {
            case accountTakedown = "AccountTakedown"
            case authFactorTokenRequired = "AuthFactorTokenRequired"
        }

        public static func createSession(host: URL, identifier: String, password: String) async throws -> Result<ATProtoServerCreateSessionResponseBody, BlueskyClientError<ATProtoCreateSessionError>> {
            let createSessionLexicon = try JSONDecoder().decode(Lexicon.self,
                                                                from: try Data(contentsOf: Bundle.module.url(forResource: "com.atproto.server.createSession",
                                                                                                             withExtension: "json")!))

            if let mainDef = createSessionLexicon.defs["main"] {
                switch mainDef {
                case .procedure(let procedure):
                    let createSessionRequestBody = ATProtoServerCreateSessionRequestBody(identifier: identifier, password: password)

                    let createSessionRequest = try ATProtoHTTPRequest(host: host,
                                                                      nsid: createSessionLexicon.id,
                                                                      parameters: [:],
                                                                      body: createSessionRequestBody,
                                                                      token: nil,
                                                                      requestable: procedure)

                    let createSessionResult: Result<ATProtoServerCreateSessionResponseBody?, ATProtoHTTPClientError<ATProtoCreateSessionError>> = await ATProtoHTTPClient.make(request: createSessionRequest)

                    switch createSessionResult {
                    case .success(let createSessionResponse):
                        guard let createSessionResponse = createSessionResponse else {
                            return .failure(.invalidResponse)
                        }

                        return .success(createSessionResponse)

                    case .failure(let error):
                        return .failure(BlueskyClientError(atProtoHTTPClientError: error))
                    }

                default:
                    return .failure(.invalidRequest)
                }
            }

            return .failure(.invalidLexicon)
        }

        public enum ATProtoRefreshSessionError: String, Decodable, Error {
            case accountTakedown = "AccountTakedown"
        }

        public static func refreshSession(host: URL, refreshToken: String) async throws -> Result<ATProtoServerRefreshSessionResponseBody, BlueskyClientError<ATProtoRefreshSessionError>> {
            let refreshSessionLexicon = try JSONDecoder().decode(Lexicon.self,
                                                                 from: try Data(contentsOf: Bundle.module.url(forResource: "com.atproto.server.refreshSession",
                                                                                                              withExtension: "json")!))

            switch refreshSessionLexicon.defs["main"] {
            case .procedure(let procedure):
                let refreshSessionRequest = try ATProtoHTTPRequest(host: host,
                                                                   nsid: refreshSessionLexicon.id,
                                                                   parameters: [:],
                                                                   body: nil,
                                                                   token: refreshToken,
                                                                   requestable: procedure)

                let refreshSessionResult: Result<ATProtoServerRefreshSessionResponseBody, ATProtoHTTPClientError<ATProtoRefreshSessionError>> = await ATProtoHTTPClient.make(request: refreshSessionRequest)

                switch refreshSessionResult {
                case .success(let refreshSessionResponse):
                    return .success(refreshSessionResponse)

                case .failure(let error):
                    return .failure(BlueskyClientError(atProtoHTTPClientError: error))
                }

            default:
                return .failure(.invalidLexicon)
            }
        }
    }

    public struct Repo {
        public enum ATProtoCreateRecordError: String, Decodable, Error {
            case invalidSwap = "InvalidSwap"
        }

        static func createRecord<Record: Encodable>(host: URL, accessToken: String, refreshToken: String, repo: String, collection: String, record: Record) async throws -> Result<(body: ATProtoRepoCreateRecordResponseBody, credentials: (accessToken: String, refreshToken: String)?), BlueskyClientError<ATProtoCreateRecordError>> {
            let createRecordRequestBody = ATProtoRepoCreateRecordRequestBody(repo: repo,
                                                                             collection: collection,
                                                                             record: record)

            return try await makeRequest(lexicon: "com.atproto.repo.createRecord",
                                         host: host,
                                         credentials: (accessToken, refreshToken),
                                         body: createRecordRequestBody,
                                         parameters: [:])
        }

        public enum ATProtoPutRecordError: String, Decodable, Error {
            case invalidSwap = "InvalidSwap"
        }

        static func putRecord<Record: Encodable>(host: URL, accessToken: String, refreshToken: String, repo: String, collection: String, rkey: String, validate: Bool? = nil, record: Record, swapRecord: String? = nil, swapCommit: String? = nil) async throws -> Result<(body: ATProtoRepoPutRecordResponseBody, credentials: (accessToken: String, refreshToken: String)?), BlueskyClientError<ATProtoPutRecordError>> {
            let putRecordRequestBody = ATProtoRepoPutRecordRequestBody(repo: repo,
                                                                       collection: collection,
                                                                       rkey: rkey,
                                                                       validate: validate,
                                                                       record: record,
                                                                       swapRecord: swapRecord,
                                                                       swapCommit: swapCommit)

            return try await makeRequest(lexicon: "com.atproto.repo.putRecord",
                                         host: host,
                                         credentials: (accessToken, refreshToken),
                                         body: putRecordRequestBody,
                                         parameters: [:])
        }

        public enum ATProtoGetRecordError: String, Decodable, Error {
            case recordNotFound = "RecordNotFound"
        }

        static func getRecord<Record: Decodable>(host: URL, accessToken: String, refreshToken: String, repo: String, collection: String, rkey: String, cid: String? = nil) async throws -> Result<(body: Record, credentials: (accessToken: String, refreshToken: String)?), BlueskyClientError<ATProtoGetRecordError>> {
            return try await makeRequest(lexicon: "com.atproto.repo.getRecord",
                                         host: host,
                                         credentials: (accessToken, refreshToken),
                                         body: nil as String?,
                                         parameters: ["repo" : repo,
                                                      "collection" : collection,
                                                      "rkey" : rkey,
                                                      "cid" : cid])
        }

        public enum ATProtoDeleteRecordError: String, Decodable, Error {
            case invalidSwap = "InvalidSwap"
        }

        static func deleteRecord(host: URL, accessToken: String, refreshToken: String, repo: String, collection: String, rkey: String) async throws -> Result<(body: ATProtoEmptyResponseBody, credentials: (accessToken: String, refreshToken: String)?), BlueskyClientError<ATProtoDeleteRecordError>> {
            let deleteRecordRequestBody = ATProtoRepoDeleteRecordRequestBody(repo: repo,
                                                                             collection: collection,
                                                                             rkey: rkey)

            return try await makeRequest(lexicon: "com.atproto.repo.deleteRecord",
                                         host: host,
                                         credentials: (accessToken, refreshToken),
                                         body: deleteRecordRequestBody,
                                         parameters: [:])
        }

        public struct ATProtoRepoUploadBlobError: Decodable, Error {
        }

        static func uploadBlob(host: URL, accessToken: String, refreshToken: String, blob: Data, encoding: String? = nil) async throws -> Result<(body: ATProtoRepoUploadBlobResponseBody, credentials: (accessToken: String, refreshToken: String)?), BlueskyClientError<ATProtoRepoUploadBlobError>> {
            return try await makeRequest(lexicon: "com.atproto.repo.uploadBlob",
                                         host: host,
                                         credentials: (accessToken, refreshToken),
                                         body: blob,
                                         parameters: [:],
                                         encoding: encoding)
        }
    }

    public struct Actor {
        public struct BlueskyGetProfilesError: Decodable, Error {
        }

        public static func getProfiles(host: URL, accessToken: String, refreshToken: String, actors: [String]) async throws -> Result<(body: BlueskyActorGetProfilesResponseBody, credentials: (accessToken: String, refreshToken: String)?), BlueskyClientError<BlueskyGetProfilesError>> {
            try await makeRequest(lexicon: "app.bsky.actor.getProfiles",
                                  host: host,
                                  credentials: (accessToken, refreshToken),
                                  body: nil as String?,
                                  parameters: ["actors" : actors])
        }


        public static func getProfile(host: URL, accessToken: String, refreshToken: String, actor: String) async throws -> Result<(body: ATProtoRepoGetRecordResponseBody<BlueskyActorProfile>, credentials: (accessToken: String, refreshToken: String)?), BlueskyClientError<Repo.ATProtoGetRecordError>> {
            return try await Repo.getRecord(host: host,
                                            accessToken: accessToken,
                                            refreshToken: refreshToken,
                                            repo: actor,
                                            collection: "app.bsky.actor.profile",
                                            rkey: "self")
        }

        public static func putProfile(host: URL, accessToken: String, refreshToken: String, repo: String, profile: BlueskyActorProfile) async throws -> Result<(body: ATProtoRepoPutRecordResponseBody, credentials: (accessToken: String, refreshToken: String)?), BlueskyClientError<Repo.ATProtoPutRecordError>> {
            return try await Repo.putRecord(host: host,
                                            accessToken: accessToken,
                                            refreshToken: refreshToken,
                                            repo: repo,
                                            collection: "app.bsky.actor.profile",
                                            rkey: "self",
                                            record: profile)
        }
    }

    public struct Graph {
        public struct BlueskyMuteThreadError: Decodable, Error {
        }

        public static func muteThread(host: URL, accessToken: String, refreshToken: String, root: String) async throws -> Result<(body: BlueskyEmptyReponseBody, credentials: (accessToken: String, refreshToken: String)?), BlueskyClientError<BlueskyMuteThreadError>> {
            let muteThreadRequestBody = BlueskyGraphMuteThreadRequestBody(root: root)

            return try await makeRequest(lexicon: "app.bsky.graph.muteThread",
                                         host: host,
                                         credentials: (accessToken, refreshToken),
                                         body: muteThreadRequestBody,
                                         parameters: [:])
        }

        public struct BlueskyUnmuteThreadError: Decodable, Error {
        }

        public static func unmuteThread(host: URL, accessToken: String, refreshToken: String, root: String) async throws -> Result<(body: BlueskyEmptyReponseBody, credentials: (accessToken: String, refreshToken: String)?), BlueskyClientError<BlueskyUnmuteThreadError>> {
            let unmuteThreadRequestBody = BlueskyGraphMuteThreadRequestBody(root: root)

            return try await makeRequest(lexicon: "app.bsky.graph.unmuteThread",
                                         host: host,
                                         credentials: (accessToken, refreshToken),
                                         body: unmuteThreadRequestBody,
                                         parameters: [:])
        }

        public struct BlueskyGetListsError: Decodable, Error {
        }

        public static func getLists(host: URL, accessToken: String, refreshToken: String, actor: String, limit: Int?, cursor: Date?) async throws -> Result<(body: BlueskyGraphGetListsResponseBody, credentials: (accessToken: String, refreshToken: String)?), BlueskyClientError<BlueskyGetListsError>> {
            var parameters: [String : Encodable] = ["actor" : actor]

            if let limit = limit {
                parameters["limit"] = limit
            }

            if let cursor = cursor {
                parameters["cursor"] = ISO8601DateFormatter().string(from: cursor)
            }

            return try await makeRequest(lexicon: "app.bsky.graph.getLists",
                                         host: host,
                                         credentials: (accessToken, refreshToken),
                                         body:  nil as String?,
                                         parameters: parameters)
        }
    }

    public struct Feed {
        public enum AuthorFeedFilter: String {
            case postsWithReplies = "posts_with_replies"
            case postsNoReplies = "posts_no_replies"
            case postsWithMedia = "posts_with_media"
            case postsAndAuthorThreads = "posts_and_author_threads"
        }

        public enum BlueskyGetAuthorFeedError: String, Decodable, Error {
            case blockedActor = "BlockedActor"
            case blockedByActor = "BlockedByActor"
        }

        public static func getAuthorFeed(host: URL, accessToken: String, refreshToken: String, actor: String, filter: AuthorFeedFilter?, limit: Int?, cursor: Date?) async throws -> Result<(body: BlueskyFeedGetAuthorFeedResponseBody, credentials: (accessToken: String, refreshToken: String)?), BlueskyClientError<BlueskyGetAuthorFeedError>> {
            var properties: [String : Encodable] = ["actor" : actor]

            if let filter = filter {
                properties["filter"] = filter.rawValue
            }

            if let cursor = cursor {
                properties["curor"] = ISO8601DateFormatter().string(from: cursor)
            }

            return try await makeRequest(lexicon: "app.bsky.feed.getAuthorFeed",
                                         host: host,
                                         credentials: (accessToken, refreshToken),
                                         body: nil as String?,
                                         parameters: properties)
        }

        public struct BlueskyGetTimelineError: Decodable, Error {
        }

        public static func getTimeline(host: URL, accessToken: String, refreshToken: String, algorithm: String, limit: Int, cursor: Date) async throws -> Result<(body: BlueskyFeedGetTimelineResponseBody, credentials: (accessToken: String, refreshToken: String)?), BlueskyClientError<BlueskyGetTimelineError>> {
            try await makeRequest(lexicon: "app.bsky.feed.getTimeline",
                                  host: host,
                                  credentials: (accessToken, refreshToken),
                                  body: nil as String?,
                                  parameters: ["algorithm" : algorithm,
                                               "limit" : limit,
                                               "cursor" : ISO8601DateFormatter().string(from: cursor)])
        }

        public enum BlueskyGetPostThreadError: String, Decodable, Error {
            case notFound = "NotFound"
        }

        public static func getPostThread(host: URL, accessToken: String, refreshToken: String, uri: String, depth: Int?, parentHeight: Int?) async throws -> Result<(body: BlueskyFeedGetPostThreadResponseBody, credentials: (accessToken: String, refreshToken: String)?), BlueskyClientError<BlueskyGetPostThreadError>> {
            var properties: [String : Encodable] = ["uri" :  uri]

            if let depth = depth {
                properties["depth"] = depth
            }

            if let parentHeight = parentHeight {
                properties["parentHeight"] = parentHeight
            }

            return try await makeRequest(lexicon: "app.bsky.feed.getPostThread",
                                         host: host,
                                         credentials: (accessToken, refreshToken),
                                         body: nil as String?,
                                         parameters: properties)
        }

        public struct BlueskyGetPostsError: Decodable, Error {
        }

        public static func getPosts(host: URL, accessToken: String, refreshToken: String, uris: [String]) async throws -> Result<(body: BlueskyFeedGetPostsResponseBody, credentials: (accessToken: String, refreshToken: String)?), BlueskyClientError<BlueskyGetPostsError>> {
            try await makeRequest(lexicon: "app.bsky.feed.getPosts",
                                  host: host,
                                  credentials: (accessToken, refreshToken),
                                  body: nil as String?,
                                  parameters: ["uris" : uris])
        }

        public static func createLike(host: URL, accessToken: String, refreshToken: String, repo: String, uri: String, cid: String) async throws -> Result<(body: ATProtoRepoCreateRecordResponseBody, credentials: (accessToken: String, refreshToken: String)?), BlueskyClientError<Repo.ATProtoCreateRecordError>> {
            let like = BlueskyFeedLike(subject: ATProtoRepoStrongRef(uri: uri,
                                                                     cid: cid),
                                       createdAt: Date())

            return try await BlueskyClient.Repo.createRecord(host: host,
                                                             accessToken: accessToken,
                                                             refreshToken: refreshToken,
                                                             repo: repo,
                                                             collection: "app.bsky.feed.like",
                                                             record: like)
        }

        public static func deleteLike(host: URL, accessToken: String, refreshToken: String, repo: String, rkey: String) async throws -> Result<(body: ATProtoEmptyResponseBody, credentials: (accessToken: String, refreshToken: String)?), BlueskyClientError<Repo.ATProtoDeleteRecordError>> {
            return try await BlueskyClient.Repo.deleteRecord(host: host,
                                                             accessToken: accessToken,
                                                             refreshToken: refreshToken,
                                                             repo: repo, collection: "app.bsky.feed.like",
                                                             rkey: rkey)
        }

        public static func createRepost(host: URL, accessToken: String, refreshToken: String, repo: String, uri: String, cid: String) async throws -> Result<(body: ATProtoRepoCreateRecordResponseBody, credentials: (accessToken: String, refreshToken: String)?), BlueskyClientError<Repo.ATProtoCreateRecordError>> {
            let repost = BlueskyFeedRepost(subject: ATProtoRepoStrongRef(uri: uri,
                                                                         cid: cid),
                                           createdAt: Date())

            return try await BlueskyClient.Repo.createRecord(host: host,
                                                             accessToken: accessToken,
                                                             refreshToken: refreshToken,
                                                             repo: repo,
                                                             collection: "app.bsky.feed.repost",
                                                             record: repost)
        }

        public static func deleteRepost(host: URL, accessToken: String, refreshToken: String, repo: String, rkey: String) async throws -> Result<(body: ATProtoEmptyResponseBody, credentials: (accessToken: String, refreshToken: String)?), BlueskyClientError<Repo.ATProtoDeleteRecordError>> {
            return try await BlueskyClient.Repo.deleteRecord(host: host,
                                                             accessToken: accessToken,
                                                             refreshToken: refreshToken,
                                                             repo: repo,
                                                             collection: "app.bsky.feed.repost",
                                                             rkey: rkey)
        }

        public enum BlueskyFeedGetActorLikesError: String, Decodable, Error {
            case blockedActor = "BlockedActor"
            case blockedByActor = "BlockedByActor"
        }

        public static func getActorLikes(host: URL, accessToken: String, refreshToken: String, actor: String, limit: Int?, cursor: Date?) async throws -> Result<(body: BlueskyFeedGetAuthorFeedResponseBody, credentials: (accessToken: String, refreshToken: String)?), BlueskyClientError<BlueskyFeedGetActorLikesError>> {
            var properties: [String : Encodable] = ["actor" : actor]

            if let limit = limit {
                properties["limit"] = limit
            }

            if let cursor = cursor {
                properties["cursor"] = cursor
            }

            return try await makeRequest(lexicon: "app.bsky.feed.getActorLikes",
                                         host: host,
                                         credentials: (accessToken, refreshToken),
                                         body: nil as String?,
                                         parameters: properties)
        }
    }
}
