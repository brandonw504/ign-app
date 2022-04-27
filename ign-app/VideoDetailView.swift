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
        ScrollView(.vertical) {
            VStack {
                Text(video.metadata.title).font(.headline)
                if let url = video.assets.last?.url {
                    VideoPlayer(player: AVPlayer(url: URL(string: url)!)).cornerRadius(15).frame(height: 200)
                }
                Divider()
                if let desc = video.metadata.metadataDescription {
                    Text(desc)
                }
            }
            .padding(10)
            .frame(alignment: .top)
            Spacer()
        }
    }
}
