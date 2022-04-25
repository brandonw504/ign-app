//
//  VideoService.swift
//  ign-app
//
//  Created by Brandon Wong on 4/24/22.
//

import Foundation
import SwiftUI

/*
 API link
 https://ign-apis.herokuapp.com/videos
 */

class VideoService: ObservableObject {
    @Published var videos: Videos = Videos(count: 0, startIndex: 0, data: [])
    
    func fetch() {
        guard let url = URL(string: "https://ign-apis.herokuapp.com/videos") else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let data = data, error == nil else {
                print("Error")
                return
            }
            
            // we now have data
            do {
                let videos = try JSONDecoder().decode(Videos.self, from: data)
                DispatchQueue.main.async {
                    self?.videos = videos
                }
            } catch {
                print(error)
            }
        }
        
        task.resume()
    }
}
