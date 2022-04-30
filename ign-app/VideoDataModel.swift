//
//  VideoDataModel.swift
//  ign-app
//
//  Created by Brandon Wong on 4/24/22.
//

import Foundation

// MARK: - Videos
struct Videos: Hashable, Codable {
    let count, startIndex: Int
    var data: [Video]
}

// MARK: - Video
struct Video: Hashable, Codable {
    let contentID: String
    let contentType: VideoContentType
    let thumbnails: [Asset]
    var metadata: VideoMetadata
    let tags: [String]
    let assets: [Asset]
    var commentCount: Int = 0

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

enum VideoSize: String, Codable {
    case compact = "compact"
    case large = "large"
    case medium = "medium"
}

enum VideoContentType: String, Codable {
    case video = "video"
}

// MARK: - Metadata
struct VideoMetadata: Hashable, Codable {
    let title, metadataDescription: String
    let publishDate: String
    var timeSincePublish: String = "0 seconds ago"
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

enum VideoNetwork: String, Codable {
    case ign = "ign"
}

enum VideoState: String, Codable {
    case published = "published"
}
