//
//  CommentDataModel.swift
//  ign-app
//
//  Created by Brandon Wong on 4/25/22.
//

import Foundation

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? newJSONDecoder().decode(Welcome.self, from: jsonData)

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
