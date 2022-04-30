//
//  VideoDetailView.swift
//  ign-app
//
//  Created by Brandon Wong on 4/26/22.
//

import SwiftUI
import AVKit

struct VideoDetailView: View {
    var video: Video
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            Rectangle().fill(Color.red).edgesIgnoringSafeArea(.top).frame(height: 0)
            ScrollView(.vertical) {
                VStack {
                    HStack {
                        Text(video.metadata.timeSincePublish).padding(3).font(.system(size: 12)).foregroundColor(.red)
                        Spacer()
                    }
                    Text(video.metadata.title).font(.headline)
                    if let url = video.assets.last?.url {
                        VideoPlayer(player: AVPlayer(url: URL(string: url)!)).cornerRadius(15).frame(height: 200)
                    }
                    Divider()
                    if let desc = video.metadata.metadataDescription {
                        ZStack {
                            RoundedRectangle(cornerRadius: 15).foregroundColor(Color(.systemGray6))
                            Text(desc).padding(8)
                        }
                    }
                }
                .padding(10)
                .frame(alignment: .top)
                Spacer()
            }
        }
        .accentColor(.white)
    }
}
