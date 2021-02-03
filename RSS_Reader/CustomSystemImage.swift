//
//  CustomIcon.swift
//  RSS_Reader
//
//  Created by Kenanja Nuding on 1/27/21.
//

import SwiftUI

/// Creates from an SystemImage a custom one
struct CustomSystemImage: View {
    /// the system image to customize
    var image: SystemImage
    /// the image style that cutomize the image
    var style: ImageStyle = .nothing
    /// the image size that cutomize the image
    var size: ImageSize = .large
    /// the color that cutomize the image
    var color: Color = Color.accentColor
    /// IconStyle that indicates the style of every icon
    @AppStorage("image_style_int") var image_style_int: Int = ImageStyle.nothing.rawValue
    /// IconSize that indicates the size of every icon
    @AppStorage("image_size_int") var image_size_int: Int = ImageSize.small.rawValue
    
    var body: some View {
        if style != .nothing {
            image.image
                .resizable()
                .scaledToFit()
                .frame(width: size.size.width*0.5, height: size.size.width*0.5)
                .padding(7)
                .cornerRadius(style.radius)
                .overlay(
                    RoundedRectangle(cornerRadius: style.radius)
                        .stroke(color, lineWidth: size.size.width*0.08)
                        .frame(width: size.size.width*0.92, height: size.size.width*0.92)
                )
                .frame(width: size.size.width, height: size.size.height)
                .foregroundColor(color)
        } else {
            switch self.size {
            case .small:
                image.image.imageScale(.small)
                    .foregroundColor(color)
            case .medium:
                image.image.imageScale(.medium)
                    .foregroundColor(color)
            case .large:
                image.image.imageScale(.large)
                    .foregroundColor(color)
            default:
                image.image
                    .resizable()
                    .scaledToFit()
                    .frame(width: size.size.width, height: size.size.width)
                    .foregroundColor(color)
            }

        }
    }
}
