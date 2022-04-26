//
//  ContentView.swift
//  ign-app
//
//  Created by Brandon Wong on 4/23/22.
//

import SwiftUI
import AVKit

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
                    image.resizable().aspectRatio(contentMode: .fit).cornerRadius(15)
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
                HStack {
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
            VStack{
                Text(video.metadata.title).font(.headline)
                AsyncImage(url: URL(string: video.thumbnails[2].url)) { image in
                    image.resizable().aspectRatio(contentMode: .fit).cornerRadius(15)
                } placeholder: {
                    ProgressView()
                }
                VideoPlayer(player: AVPlayer(url:  URL(string: video.assets.last!.url)!)).cornerRadius(15).frame(height: 200)
                if let desc = video.metadata.metadataDescription {
                    Text(desc)
                }
                HStack {
                    Image(systemName: "message")
                    Text("\(video.commentCount)")
                }
                .padding(5)
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
