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
            if (author.thumbnail != "") {
                AsyncImage(url: URL(string: author.thumbnail)) { image in
                    image.resizable().aspectRatio(contentMode: .fit).cornerRadius(25)
                } placeholder: {
                    ProgressView()
                }
                .padding(3)
                .frame(width: 35, height: 35)
            }
            Text(author.name).font(.system(size: 12))
            Spacer()
        }
    }
}

struct ArticleView: View {
    var article: Article
    
    var body: some View {
        Section {
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
                Divider()
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
                        Text(video.metadata.timeSincePublish).padding(3).font(.system(size: 12)).foregroundColor(.red)
                        Spacer()
                    }
                    Divider()
                    if let url = video.thumbnails.last?.url {
                        ZStack {
                            Image(systemName: "play")
                            AsyncImage(url: URL(string: url)) { image in
                                image.resizable().aspectRatio(contentMode: .fit).cornerRadius(15)
                            } placeholder: {
                                ProgressView()
                            }
                        }
                    }
                    HStack {
                        Text(video.metadata.title).font(.headline)
                        Spacer()
                    }
                    Divider()
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
    
    init() {
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white]
    }
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .topLeading) {
                Rectangle().fill(Color.red).edgesIgnoringSafeArea(.top).frame(height: 0)
                Divider()
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
                            HStack {
                                Spacer()
                                ProgressView()
                                Spacer()
                            }
                            .onAppear {
                                articleService.fetch()
                                ArticleService.startingFrom += 10
                            }
                        }
                        .navigationTitle("IGN")
                        .navigationBarTitleDisplayMode(.inline)
                    } else {
                        List {
                            ForEach(videoService.videos.data, id: \.self) { video in
                                VideoView(video: video)
                            }
                            HStack {
                                Spacer()
                                ProgressView()
                                Spacer()
                            }
                            .onAppear {
                                videoService.fetch()
                                VideoService.startingFrom += 10
                            }
                        }
                        .navigationTitle("IGN")
                        .navigationBarTitleDisplayMode(.inline)
                    }
                }
            }
        }
        .navigationViewStyle(.stack)
        .edgesIgnoringSafeArea(.all)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
