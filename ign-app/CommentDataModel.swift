//
//  CommentDataModel.swift
//  ign-app
//
//  Created by Brandon Wong on 4/25/22.
//

import Foundation

// MARK: - Comments
struct Comments: Codable {
    let count: Int
    let content: [CommentCount]
}

// MARK: - CommentCount
struct CommentCount: Codable {
    let id: String
    let count: Int
}
