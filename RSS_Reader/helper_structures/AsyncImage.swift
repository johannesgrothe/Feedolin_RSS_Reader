//
//  AsyncImage.swift
//  RSS_Reader
//
//  Created by Johannes Grothe on 20.11.20.
//

import Foundation
import SwiftUI

class AsyncImage: ObservableObject {
    
    init(_ url: String) {
        self.url = URL(string: url)
        load()
    }
    
    private let url: URL?
    
    @Published var img: Image = Image(systemName: "newspaper")
    
    private func load() {
        if url != nil {
            print("Loading image from '\(url!.absoluteString)'")
            downloadImage(from: url!)
        }
    }
    
    private func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
       URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    private func downloadImage(from url: URL) {
       getData(from: url) {
          data, response, error in
          guard let data = data, error == nil else {
            print("Error loading Image")
            return
          }
          DispatchQueue.main.async() {
            let buf_img = UIImage(data: data)
            if buf_img != nil {
                self.img = Image(uiImage: buf_img!)
                print("Image Loadad!!")
            }
         }
       }
    }
}
