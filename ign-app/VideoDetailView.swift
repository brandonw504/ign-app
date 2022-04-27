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
    @State private var comment: String = ""
    
    var body: some View {
        VStack {
            Text(video.metadata.title).font(.headline)
            if let url = video.assets.last?.url {
                VideoPlayer(player: AVPlayer(url: URL(string: url)!)).cornerRadius(15).frame(height: 200)
                if let desc = video.metadata.metadataDescription {
                    Text(desc)
                }
            }
            TextField("Comment...", text: $comment)
//                .onSubmit {
//
//                }
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
        }
        .padding(10)
        .frame(alignment: .top)
        Spacer()
    }
}
