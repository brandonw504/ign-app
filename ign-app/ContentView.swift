//
//  ContentView.swift
//  ign-app
//
//  Created by Brandon Wong on 4/23/22.
//

import SwiftUI

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
                            if (!ArticleService.doneShowing) {
                                HStack {
                                    Spacer()
                                    ProgressView()
                                    Spacer()
                                }
                                .onAppear {
                                    articleService.fetch()
                                    ArticleService.startingFrom += 10
                                    if (ArticleService.startingFrom >= 300) {
                                        ArticleService.doneShowing = true
                                    }
                                }
                            }
                        }
                        .navigationTitle("IGN")
                        .navigationBarTitleDisplayMode(.inline)
                    } else {
                        List {
                            ForEach(videoService.videos.data, id: \.self) { video in
                                VideoView(video: video)
                            }
                            if (!VideoService.doneShowing) {
                                HStack {
                                    Spacer()
                                    ProgressView()
                                    Spacer()
                                }
                                .onAppear {
                                    videoService.fetch()
                                    VideoService.startingFrom += 10
                                    if (VideoService.startingFrom >= 300) {
                                        VideoService.doneShowing = true
                                    }
                                }
                            }
                        }
                        .navigationTitle("IGN")
                        .navigationBarTitleDisplayMode(.inline)
                    }
                }
            }
        }
        .navigationViewStyle(.stack)
        .accentColor(.white)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
