//
//  VideoDataModel.swift
//  ign-app
//
//  Created by Brandon Wong on 4/24/22.
//

import Foundation
import SwiftUI

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? newJSONDecoder().decode(Welcome.self, from: jsonData)

// MARK: - Videos
struct Videos: Hashable, Codable {
    let count, startIndex: Int
    let data: [Video]
}

// MARK: - Video
struct Video: Hashable, Codable {
    let contentID: String
    let contentType: VideoContentType
    let thumbnails: [Asset]
    let metadata: VideoMetadata
    let tags: [String]
    let assets: [Asset]

    enum CodingKeys: String, CodingKey {
        case contentID = "contentId"
        case contentType, thumbnails, metadata, tags, assets
    }
}

// MARK: - Asset
struct Asset: Hashable, Codable {
    let url: String
    let height, width: Int
    let size: VideoSize?
}

enum VideoSize: String, Hashable, Codable {
    case compact = "compact"
    case large = "large"
    case medium = "medium"
}

enum VideoContentType: String, Hashable, Codable {
    case video = "video"
}

// MARK: - Metadata
struct VideoMetadata: Hashable, Codable {
    let title, metadataDescription: String
    let publishDate: String
    let slug: String
    let networks: [VideoNetwork]
    let state: VideoState
    let duration: Int
    let videoSeries: String

    enum CodingKeys: String, CodingKey {
        case title
        case metadataDescription = "description"
        case publishDate, slug, networks, state, duration, videoSeries
    }
}

enum VideoNetwork: String, Hashable, Codable {
    case ign = "ign"
}

enum VideoState: String, Hashable, Codable {
    case published = "published"
}
