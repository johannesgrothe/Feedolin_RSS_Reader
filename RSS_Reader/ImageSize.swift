//
//  IconSize.swift
//  RSS_Reader
//
//  Created by Kenanja Nuding on 1/27/21.
//

import SwiftUI

/// ImageSize that has much more different sizes than the normal
enum ImageSize: Int {
    case xxsmall = 0
    case xsmall
    case small
    case medium
    case large
    case xlarge
    case xxlarge
    case xxxlarge
    
    /// private scale to easy write
    private var scale: CGFloat {
        switch self {
        case .xxsmall:
            return 8
        case .xsmall:
            return 16
        case .small:
            return 24
        case .medium:
            return 32
        case .large:
            return 40
        case .xlarge:
            return 48
        case .xxlarge:
            return 56
        case .xxxlarge:
            return 64
        }
    }
    
    /// returns the CGSize of specific scale
    var size: CGSize {
        switch self {
        default:
            return CGSize(width: self.scale, height: self.scale)
        }
    }
}
