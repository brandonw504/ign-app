//
//  ArticleDataModel.swift
//  ign-app
//
//  Created by Brandon Wong on 4/24/22.
//

import Foundation

// MARK: - Articles
struct Articles: Codable {
    let count, startIndex: Int
    var data: [Article]
}

// MARK: - Article
struct Article: Hashable, Codable {
    let contentID: String
    let contentType: ArticleContentType
    let thumbnails: [ArticleThumbnail]
    var metadata: ArticleMetadata
    let tags: [String]
    let authors: [Author]
    var commentCount: Int = 0

    enum CodingKeys: String, CodingKey {
        case contentID = "contentId"
        case contentType, thumbnails, metadata, tags, authors
    }
}

// MARK: - Author
struct Author: Hashable, Codable {
    let name: String
    let thumbnail: String
}

enum ArticleContentType: String, Codable {
    case article = "article"
}

// MARK: - Metadata
struct ArticleMetadata: Hashable, Codable {
    let headline: String
    var metadataDescription: String = ""
    let publishDate: String
    var timeSincePublish: String = "0 seconds ago"
    let slug: String
    let networks: [ArticleNetwork]
    let state: ArticleState
    let objectName: String?

    enum CodingKeys: String, CodingKey {
        case headline
        case metadataDescription = "description"
        case publishDate, slug, networks, state, objectName
    }
}

enum ArticleNetwork: String, Codable {
    case ign = "ign"
}

enum ArticleState: String, Codable {
    case published = "published"
}

// MARK: - Thumbnail
struct ArticleThumbnail: Hashable, Codable {
    let url: String
    let size: ArticleSize
    let width, height: Int
}

enum ArticleSize: String, Codable {
    case compact = "compact"
    case large = "large"
    case medium = "medium"
}
