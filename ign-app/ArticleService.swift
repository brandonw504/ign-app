//
//  ViewModel.swift
//  ign-app
//
//  Created by Brandon Wong on 4/24/22.
//

import Foundation

class ArticleService: ObservableObject {
    static var doneShowing = false
    static var startingFrom = 40
    @Published var articles: Articles = Articles(count: 0, startIndex: 0, data: [])
    let dateFormatter = ISO8601DateFormatter()
    
    func fetch() {
        guard let url = URL(string: "https://ign-apis.herokuapp.com/articles?startIndex=\(ArticleService.startingFrom)") else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            // make sure there is actually data
            guard let data = data, error == nil else {
                print("Error: no data")
                return
            }
            
            // we now have data
            do {
                let articles = try JSONDecoder().decode(Articles.self, from: data)
                DispatchQueue.main.async {
                    guard let self = self else {
                        print("Error: self is nil")
                        return
                    }
                    
                    // add new data to what we already have
                    self.articles.data.append(contentsOf: articles.data)
                    let commentService = CommentService()
                    
                    // go through each article and fill in the number of comments and the time since it was published
                    let articlesSize = self.articles.data.count - 1
                    for (index, article) in articles.data.enumerated() {
                        // finds the number of comments based on the article's contentID
                        commentService.contentID = article.contentID
                        commentService.fetch { comments in
                            self.articles.data[articlesSize - index].commentCount = comments?.content.first?.count ?? 0
                        }
                        
                        // calculates the time in between the now and the article's publish date
                        let date = self.dateFormatter.date(from: article.metadata.publishDate)!
                        let now = Date()
                        self.articles.data[articlesSize - index].metadata.timeSincePublish = now.offset(from: date)
                    }
                }
            } catch {
                print(error)
            }
        }
        
        task.resume()
    }
}
