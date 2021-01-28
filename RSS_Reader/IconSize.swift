//
//  IconSize.swift
//  RSS_Reader
//
//  Created by Kenanja Nuding on 1/27/21.
//

import SwiftUI

enum IconSize: Int {
    case xxsmall = 0
    case xsmall
    case small
    case medium
    case large
    case xlarge
    case xxlarge
    case xxxlarge
    
    var width: CGFloat {
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
    
    var size: CGSize {
        switch self {
        case .xxsmall:
            return CGSize(width: 8, height: 8)
        case .xsmall:
            return CGSize(width: 16, height: 16)
        case .small:
            return CGSize(width: 24, height: 24)
        case .medium:
            return CGSize(width: 32, height: 32)
        case .large:
            return CGSize(width: 40, height: 40)
        case .xlarge:
            return CGSize(width: 48, height: 48)
        case .xxlarge:
            return CGSize(width: 56, height: 56)
        case .xxxlarge:
            return CGSize(width: 64, height: 64)
        }
    }
}
