//
//  Savable_Interface.swift
//  RSS_Reader
//
//  Created by Johannes Grothe on 21.01.21.
//

import Foundation

protocol Savable {
    func make_persistent()
    
    func save()
}
