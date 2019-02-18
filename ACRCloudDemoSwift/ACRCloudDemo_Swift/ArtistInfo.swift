//
//  ArtistInfo.swift
//  ACRCloudDemo_Swift
//
//  Created by Aprcot on 1/31/19.
//  Copyright © 2019 olym.yin. All rights reserved.
//

// To parse the JSON, add this file to your project and do:
//
//   let artistInfo = try? newJSONDecoder().decode(ArtistInfo.self, from: jsonData)

import Foundation

typealias ArtistInfo = [ArtistInfoElement]

struct ArtistInfoElement: Codable {
    let externalUrls: ExternalUrls
    let followers: Followers
    let genres: [String]
    let href: String
    let id: String
    let images: [Image]
    let name: String
    let popularity: Int
    let type: TypeEnum
    let uri: String
    
    enum CodingKeys: String, CodingKey {
        case externalUrls = "external_urls"
        case followers, genres, href, id, images, name, popularity, type, uri
    }
}

struct ExternalUrls: Codable {
    let spotify: String
}

struct Followers: Codable {
    let href: JSONNull?
    let total: Int
}

struct Image: Codable {
    let height: Int
    let url: String
    let width: Int
}

enum TypeEnum: String, Codable {
    case artist = "artist"
}

// MARK: Encode/decode helpers

class JSONNull: Codable, Hashable {
    
    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }
    
    public var hashValue: Int {
        return 0
    }
    
    public init() {}
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}
