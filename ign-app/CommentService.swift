//
//  CommentService.swift
//  ign-app
//
//  Created by Brandon Wong on 4/25/22.
//

import Foundation

/*
 API link
 https://ign-apis.herokuapp.com/comments?ids=60a83888e4b0d3ea05cbde3d
 */

class CommentService: ObservableObject {
    @Published var comments: Comments = Comments(count: 0, content: [])
    var contentID = ""
    
    func fetch(completion: @escaping(Comments?) -> Void) {
        guard let url = URL(string: "https://ign-apis.herokuapp.com/comments?ids=\(contentID)") else {
            completion(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            // make sure there is actually data
            guard let data = data, error == nil else {
                print("Error")
                completion(nil)
                return
            }
            
            // we now have data
            do {
                let comments = try JSONDecoder().decode(Comments.self, from: data)
                DispatchQueue.main.async {
                    self?.comments = comments
                    completion(comments)
                }
            } catch {
                completion(nil)
                print(error)
            }
        }
        
        task.resume()
    }
}
