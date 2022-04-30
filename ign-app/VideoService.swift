//
//  VideoService.swift
//  ign-app
//
//  Created by Brandon Wong on 4/24/22.
//

import Foundation

class VideoService: ObservableObject {
    static var doneShowing = false
    static var startingFrom = 0
    @Published var videos: Videos = Videos(count: 0, startIndex: 0, data: [])
    let dateFormatter = ISO8601DateFormatter()
    
    func fetch() {
        guard let url = URL(string: "https://ign-apis.herokuapp.com/videos?startIndex=\(VideoService.startingFrom)") else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            // make sure there is actually data
            guard let data = data, error == nil else {
                print("Error no data")
                return
            }
            
            // we now have data
            do {
                let videos = try JSONDecoder().decode(Videos.self, from: data)
                DispatchQueue.main.async {
                    guard let self = self else {
                        print("Error: self is nil")
                        return
                    }
                    
                    // add new data to what we already have
                    self.videos.data.append(contentsOf: videos.data)
                    let commentService = CommentService()
                    
                    // go through each video and fill in the number of comments and the time since it was published
                    let videosSize = self.videos.data.count - 1
                    for (index, video) in videos.data.enumerated() {
                        // finds the number of comments based on the video's contentID
                        commentService.contentID = video.contentID
                        commentService.fetch { comments in
                            self.videos.data[videosSize - index].commentCount = comments?.content.first?.count ?? 0
                        }
                        
                        // calculates the time in between the now and the video's publish date
                        let date = self.dateFormatter.date(from: video.metadata.publishDate)!
                        let now = Date()
                        self.videos.data[videosSize - index].metadata.timeSincePublish = now.offset(from: date)
                    }
                }
            } catch {
                print(error)
            }
        }
        
        task.resume()
    }
}
