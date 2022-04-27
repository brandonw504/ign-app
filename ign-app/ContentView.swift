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
                image.resizable().aspectRatio(contentMode: .fit).cornerRadius(15)
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
            VStack {
                HStack {
                    Text(article.metadata.timeSincePublish).padding(3).font(.system(size: 12))
                    Spacer()
                }
                Text(article.metadata.headline).font(.headline).padding(3)
                if let url = article.thumbnails.last?.url {
                    AsyncImage(url: URL(string: url)) { image in
                        image.resizable().aspectRatio(contentMode: .fit).cornerRadius(15)
                    } placeholder: {
                        ProgressView()
                    }
                }
                if let desc = article.metadata.metadataDescription {
                    Text(desc)
                }
                if let authors = article.authors {
                    ForEach(authors, id: \.self) { author in
                        AuthorView(author: author)
                    }
                }
                HStack {
                    Spacer()
                    Image(systemName: "message")
                    Text("\(article.commentCount)")
                }
                .padding(5)
            }
        }
    }
}

struct VideoView: View {
    var video: Video
    
    var body: some View {
        Section {
            ZStack {
                VStack {
                    HStack {
                        Text(video.metadata.timeSincePublish).padding(3).font(.system(size: 12))
                        Spacer()
                    }
                    if let url = video.thumbnails.last?.url {
                        AsyncImage(url: URL(string: url)) { image in
                            image.resizable().aspectRatio(contentMode: .fit).cornerRadius(15)
                        } placeholder: {
                            ProgressView()
                        }
                    }
                    Text(video.metadata.title).font(.headline)
                    HStack {
                        Spacer()
                        Image(systemName: "message")
                        Text("\(video.commentCount)")
                    }
                    .padding(5)
                }
                NavigationLink(destination: VideoDetailView(video: video)) {
                    EmptyView()
                }
            }
        }
    }
}

struct ContentView: View {
    @StateObject var articleService = ArticleService()
    @StateObject var videoService = VideoService()
    let contentTypes = ["Articles", "Videos"]
    @State var content = "Articles"
    
    var body: some View {
        NavigationView {
            VStack {
                Picker("Choose Content", selection: $content) {
                    ForEach(contentTypes, id: \.self) {
                        Text($0)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(10)
                
                if (content == "Articles") {
                    List {
                        ForEach(articleService.articles.data, id: \.self) { article in
                            ArticleView(article: article)
                        }
                    }
                    .navigationTitle("IGN")
                    .navigationBarTitleDisplayMode(.inline)
                    .onAppear {
                        articleService.fetch()
                    }
                } else {
                    List {
                        ForEach(videoService.videos.data, id: \.self) { video in
                            VideoView(video: video)
                        }
                    }
                    .navigationTitle("IGN")
                    .navigationBarTitleDisplayMode(.inline)
                    .onAppear {
                        videoService.fetch()
                    }
                }
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
