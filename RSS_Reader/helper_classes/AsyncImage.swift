//
//  AsyncImage.swift
//  RSS_Reader
//
//  Created by Johannes Grothe on 20.11.20.
//

import Foundation
import SwiftUI

class AsyncImage: ObservableObject, Codable {
    
    enum CodingKeys: CodingKey {
        case url, default_img, stored_img
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(url, forKey: .url)
        try container.encode(default_img, forKey: .default_img)
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        url = try container.decode(URL?.self, forKey: .url)
        default_img = try container.decode(String.self, forKey: .default_img)
    }

    init(_ url: String, default_image: String?) {
        self.url = URL(string: url)
        if default_image != nil {
            self.default_img = default_image!
        } else {
            self.default_img = "xmark.octagon"
        }
    }
    
    // URL of the image to be loaded
    let url: URL?
    
    // Default image to be displayed
    private let default_img: String
    
    private var stored_img: Image?
    
    var img: Image {
        get {
            if stored_img != nil {
                return stored_img!
            }
            load()
            return Image(default_img)
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
