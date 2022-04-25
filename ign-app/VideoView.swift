//
//  VideoView.swift
//  ign-app
//
//  Created by Brandon Wong on 4/24/22.
//

import SwiftUI

struct VideoView: View {
    var video: Video
    
    var body: some View {
        Section {
            VStack{
                Text(video.metadata.title).font(.headline)
                AsyncImage(url: URL(string: video.thumbnails[2].url)) { image in
                    image.resizable().aspectRatio(contentMode: .fill).cornerRadius(15)
                } placeholder: {
                    ProgressView()
                }
                if let desc = video.metadata.metadataDescription {
                    Text(desc)
                }
            }
        }
    }
}


struct VideosView: View {
    @StateObject var videoService = VideoService()
    
    var body: some View {
        NavigationView {
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
        .navigationViewStyle(.stack)
    }
}

struct VideoView_Previews: PreviewProvider {
    static var previews: some View {
        VideosView()
    }
}
