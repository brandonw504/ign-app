//
//  ViewModel.swift
//  ign-app
//
//  Created by Brandon Wong on 4/24/22.
//

import Foundation

/*
 API link
 "https://ign-apis.herokuapp.com/articles?startIndex=30&count=5"
 */

class ArticleService: ObservableObject {
    @Published var articles: Articles = Articles(count: 0, startIndex: 0, data: [])
    let dateFormatter = ISO8601DateFormatter()
    
    func fetch() {
        guard let url = URL(string: "https://ign-apis.herokuapp.com/articles") else {
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
                let articles = try JSONDecoder().decode(Articles.self, from: data)
                DispatchQueue.main.async {
                    self?.articles = articles
                    let commentService = CommentService()
                    
                    // go through each article and fill in the number of comments and the time since it was published
                    for (index, article) in articles.data.enumerated() {
                        commentService.contentID = article.contentID
                        commentService.fetch { comments in
                            self?.articles.data[index].commentCount = comments?.content.first?.count ?? 0
                        }
                        
                        let date = self?.dateFormatter.date(from: article.metadata.publishDate)!
                        let now = Date()
                        self?.articles.data[index].metadata.timeSincePublish = now.offset(from: date!)
                    }
                }
            } catch {
                print(error)
            }
        }
        
        task.resume()
    }
}
