//
//  ImageStyle.swift
//  RSS_Reader
//
//  Created by Kenanja Nuding on 1/27/21.
//

import SwiftUI

enum ImageStyle: Int {
    case nothing = 0
    case square
    case square_rounded
    case circle
    
    var radius: CGFloat {
        switch self {
        case .nothing:
            return -1
        case .square:
            return 1
        case .square_rounded:
            return 5
        case .circle:
            return 100
        }
    }
}
