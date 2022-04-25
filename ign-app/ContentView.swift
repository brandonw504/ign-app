//
//  ContentView.swift
//  ign-app
//
//  Created by Brandon Wong on 4/23/22.
//

import SwiftUI

struct AuthorView: View {
    var author: Author
    
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: author.thumbnail)) { image in
                image.resizable().aspectRatio(contentMode: .fill).cornerRadius(15)
            } placeholder: {
                ProgressView()
            }
            .padding(3)
            Text(author.name)
        }
    }
}

struct ArticleView: View {
    var article: Article
    
    var body: some View {
        Section {
            VStack{
                Text(article.metadata.headline).font(.headline).padding(3)
                AsyncImage(url: URL(string: article.thumbnails[2].url)) { image in
                    image.resizable().aspectRatio(contentMode: .fill).cornerRadius(15)
                } placeholder: {
                    ProgressView()
                }
                if let desc = article.metadata.metadataDescription {
                    Text(desc)
                }
                if let authors = article.authors {
                    ForEach(authors, id: \.self) { author in
                        AuthorView(author: author)
                    }
                }
            }
        }
    }
}

struct ContentView: View {
    @StateObject var articleService = ArticleService()
    
    var body: some View {
        NavigationView {
            List {
                ForEach(articleService.articles.data, id: \.self) { article in
                    ArticleView(article: article)
                }
            }
            .navigationTitle("IGN")
            .onAppear {
                articleService.fetch()
            }
        }
        .navigationViewStyle(.stack)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
