//
//  AsyncImage+CoreDataClass.swift
//  RSS_Reader
//
//  Created by Emircan Duman on 29.09.21.
//
//

import Foundation
import CoreData
import SwiftUI

public class AsyncImage: NSManagedObject {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<AsyncImage> {
        return NSFetchRequest<AsyncImage>(entityName: "AsyncImage")
    }
    
    @NSManaged public var url: URL?
    @NSManaged public var default_img: String
    private var stored_img: Image?
    
    convenience init(_ url: String, default_img: String?) {
        self.init()
        self.url = URL(string: url)
        if default_img != nil {
            self.default_img = default_img!
        } else {
            self.default_img = "xmark.octagon"
        }
    }
    
    var img: Image {
        get {
            if stored_img != nil {
                return stored_img!
            }
            load()
            return Image(systemName: self.default_img)
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

extension AsyncImage : Identifiable {
    
}
