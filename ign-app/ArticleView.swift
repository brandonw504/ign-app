//
//  ArticleView.swift
//  ign-app
//
//  Created by Brandon Wong on 4/29/22.
//

import SwiftUI

struct AuthorView: View {
    var author: Author
    
    var body: some View {
        HStack {
            // while the image is loading or if an image doesn't exist, displays a silhouette
            AsyncImage(url: URL(string: author.thumbnail)) { image in
                image.resizable().aspectRatio(contentMode: .fit).cornerRadius(25)
            } placeholder: {
                Image(systemName: "person.crop.circle").resizable().aspectRatio(contentMode: .fit)
            }
            .padding(3)
            .frame(width: 35, height: 35)
            
            Text(author.name).font(.system(size: 12)).padding(3)
            Spacer()
        }
    }
}

struct ArticleView: View {
    var article: Article
    
    var body: some View {
        Section {
            ZStack {
                VStack {
                    HStack {
                        Text(article.metadata.timeSincePublish).padding(3).font(.system(size: 12)).foregroundColor(.red)
                        Spacer()
                    }
                    
                    Divider()
                    
                    HStack {
                        Text(article.metadata.headline).font(.headline).padding(3)
                        Spacer()
                    }
                    
                    if let url = article.thumbnails.last?.url {
                        // show a progress view until the image loads
                        AsyncImage(url: URL(string: url)) { image in
                            image.resizable().aspectRatio(contentMode: .fit).cornerRadius(15)
                        } placeholder: {
                            ProgressView()
                        }
                    }
                    
                    if let desc = article.metadata.metadataDescription {
                        HStack {
                            Text(desc.stringByDecodingHTMLEntities)
                            Spacer()
                        }
                    }
                    
                    if let authors = article.authors {
                        ForEach(authors, id: \.self) { author in
                            AuthorView(author: author)
                        }
                    }
                    
                    Divider()
                    
                    HStack {
                        Spacer()
                        Image(systemName: "message")
                        Text("\(article.commentCount)")
                    }
                    .padding(5)
                }
                
                if let url = "https://ign.com/articles/\(article.metadata.slug)" {
                    Link(destination: URL(string: url)!) {
                        EmptyView()
                    }
                }
            }
        }
    }
}
