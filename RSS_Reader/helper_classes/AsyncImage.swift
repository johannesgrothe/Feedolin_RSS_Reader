//
//  AsyncImage.swift
//  RSS_Reader
//
//  Created by Johannes Grothe on 20.11.20.
//

import Foundation
import SwiftUI

class AsyncImage: ObservableObject {
    
    init(_ url: String, default_image: String?) {
        self.url = URL(string: url)
        if default_image != nil {
            self.default_img = Image(systemName: default_image!)
        } else {
            self.default_img = Image(systemName: "xmark.octagon")
        }
    }
    
    // URL of the image to be loaded
    let url: URL?
    
    // Default image to be displayed
    private let default_img: Image
    
    private var stored_img: Image?
    
    var img: Image {
        get {
            if stored_img != nil {
                return stored_img!
            }
            load()
            return default_img
        }
        set(newValue) {
            stored_img = newValue
            objectWillChange.send()
        }
    }
    
    private func load() {
        if stored_img != nil {
            print("Image already loaded")
            return
        }
        if url == nil {
            print("Cannot Load: URL is nil")
            return
        }
        print("Loading image from '\(url!.absoluteString)'")
        downloadImage(from: url!)
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
                print("Loding image successfull.")
                self.img = Image(uiImage: buf_img!)
            }
         }
       }
    }
}

class AsyncImageContainer: ObservableObject {
    
}
