//
//  VideoService.swift
//  ign-app
//
//  Created by Brandon Wong on 4/24/22.
//

import Foundation

/*
 API link
 https://ign-apis.herokuapp.com/videos
 */

class VideoService: ObservableObject {
    @Published var videos: Videos = Videos(count: 0, startIndex: 0, data: [])
    let dateFormatter = ISO8601DateFormatter()
    
    func fetch() {
        guard let url = URL(string: "https://ign-apis.herokuapp.com/videos") else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            // make sure there is actually data
            guard let data = data, error == nil else {
                print("Error")
                return
            }
            
            // we now have data
            do {
                let videos = try JSONDecoder().decode(Videos.self, from: data)
                DispatchQueue.main.async {
                    self?.videos = videos
                    let commentService = CommentService()
                    
                    // go through each video and fill in the number of comments and the time since it was published
                    for (index, video) in videos.data.enumerated() {
                        commentService.contentID = video.contentID
                        commentService.fetch { comments in
                            self?.videos.data[index].commentCount = comments?.content.first?.count ?? 0
                        }
                        
                        let date = self?.dateFormatter.date(from: video.metadata.publishDate)!
                        let now = Date()
                        self?.videos.data[index].metadata.timeSincePublish = now.offset(from: date!)
                    }
                }
            } catch {
                print(error)
            }
        }
        
        task.resume()
    }
}
