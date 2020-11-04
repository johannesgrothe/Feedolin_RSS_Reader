//
//  Article.swift
//  RSS_Reader
//
//  Created by Emircan Duman on 04.11.20.
//

import UIKit
import SwiftUI

struct Article: Hashable, Codable, Identifiable{
    
    var id: Int
    
    var title: String
    
    var description: String
    
    var media_thumbnail_name: String
    
    var link: String
    
    var pub_date: String
    
    var author: String
    
    var guid: String

}

extension Article {
    var image: Image {
        ImageStore.shared.image(name: media_thumbnail_name)
    }
}
