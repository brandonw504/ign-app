//
//  ViewModel.swift
//  ign-app
//
//  Created by Brandon Wong on 4/24/22.
//

import Foundation

/*
 API link
 https://ign-apis.herokuapp.com/articles
 */

class ArticleService: ObservableObject {
    @Published var articles: Articles = Articles(count: 0, startIndex: 0, data: [])
    
    func fetch() {
        guard let url = URL(string: "https://ign-apis.herokuapp.com/articles") else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
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
                    for (index, article) in articles.data.enumerated() {
                        commentService.contentID = article.contentID
                        commentService.fetch { comments in
                            self?.articles.data[index].commentCount = comments?.content.first?.count ?? 0
                        }
                    }
                }
            } catch {
                print(error)
            }
        }
        
        task.resume()
    }
}
