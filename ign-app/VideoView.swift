//
//  VideoView.swift
//  ign-app
//
//  Created by Brandon Wong on 4/29/22.
//

import SwiftUI

struct VideoView: View {
    var video: Video
    
    var body: some View {
        Section {
            ZStack {
                // cover up the chevron that normally appears on the right
                NavigationLink(destination: VideoDetailView(video: video)) {
                    EmptyView()
                }
                
                VStack {
                    HStack {
                        Text(video.metadata.timeSincePublish).padding(3).font(.system(size: 12)).foregroundColor(.red)
                        Spacer()
                    }
                    
                    Divider()
                    
                    if let url = video.thumbnails.last?.url {
                        ZStack (alignment: .bottomLeading) {
                            // show a progress view until the image loads
                            AsyncImage(url: URL(string: url)) { image in
                                image.resizable().aspectRatio(contentMode: .fit).cornerRadius(15)
                            } placeholder: {
                                ProgressView()
                            }
                            
                            Circle().frame(width: 47, height: 47).padding(5).foregroundColor(Color.white)
                            Image(systemName: "play.circle.fill").resizable().padding(7).foregroundColor(Color.red).frame(width: 57, height: 57)
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
            }
        }
    }
}

