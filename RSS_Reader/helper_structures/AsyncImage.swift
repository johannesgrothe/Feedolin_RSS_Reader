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
    }
    
    private let url: URL?
    
    @Published private var stored_img: Image?
//    {
//        willSet {
//            objectWillChange.send()
//        }
//    }
    
//    private var stored_img = Image(systemName: "newspaper")  {
//        willSet {
//            objectWillChange.send()
//        }
//    }
    
    /**
     Computed property, loads the image async
     */
    var img: Image {
        if stored_img == nil {
            stored_img = Image(systemName: "newspaper")
            load()
        }
        return stored_img!
    }
    
//    lazy var img: Image = {
//        load()
//        return stored_img
//    }()
    
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
             return
          }
          DispatchQueue.main.async() {
            let buf_img = UIImage(data: data)
            if buf_img != nil {
                self.stored_img = Image(uiImage: buf_img!)
                self.objectWillChange.send()
                print("Image Loadad!!")
            }
         }
       }
    }
}
