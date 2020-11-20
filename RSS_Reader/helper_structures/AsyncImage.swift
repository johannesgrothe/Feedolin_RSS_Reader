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
        self.url = url
    }
    
    let url: String
    private var img: Image?
    
    var image: Image? {
        get {
            return nil
        }
    }
}
