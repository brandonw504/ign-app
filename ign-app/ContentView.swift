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
                                // start loading the next batch when you reach the bottom of the page and the progress view appears
                                HStack {
                                    Spacer()
                                    ProgressView()
                                    Spacer()
                                }
                                .onAppear {
                                    articleService.fetch()
                                    // loads 10 at a time, so we start loading from there for the next cycle
                                    ArticleService.startingFrom += 10
                                    // make sure that we don't keep trying to load articles past 300, as specified in the API
                                    if (ArticleService.startingFrom >= 300) {
                                        ArticleService.doneShowing = true
                                    }
                                }
                            }
                        }
                        
                    } else {
                        List {
                            ForEach(videoService.videos.data, id: \.self) { video in
                                VideoView(video: video)
                            }
                            if (!VideoService.doneShowing) {
                                // start loading the next batch when you reach the bottom of the page and the progress view appears
                                HStack {
                                    Spacer()
                                    ProgressView()
                                    Spacer()
                                }
                                .onAppear {
                                    videoService.fetch()
                                    // loads 10 at a time, so we start loading from there for the next cycle
                                    VideoService.startingFrom += 10
                                    // make sure that we don't keep trying to load articles past 300, as specified in the API
                                    if (VideoService.startingFrom >= 300) {
                                        VideoService.doneShowing = true
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("IGN")
            .navigationBarTitleDisplayMode(.inline)
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
