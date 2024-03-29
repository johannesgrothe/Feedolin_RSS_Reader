//
//  CustomImage.swift
//  RSS_Reader
//
//  Created by Kenanja Nuding on 1/27/21.
//

import SwiftUI

/// Creates from an Image a custom one
struct CustomImage: View {
    /// the image to customize
    var image: Image
    /// the image style that cutomize the image
    var style: ImageStyle = .circle
    /// the image size that cutomize the image
    var size: ImageSize = .xlarge
    /// the color that cutomize the image
    var color: Color = Color.accentColor
    /// IconStyle that indicates the style of every icon
    @AppStorage("image_style") var image_style: ImageStyle = .nothing
    /// IconSize that indicates the size of every icon
    @AppStorage("image_size") var image_size: ImageSize = .large
    
    var body: some View {
        if style != .nothing {
            image
                .resizable()
                .scaledToFit()
                .frame(width: size.size.width, height: size.size.height)
                .cornerRadius(style.radius)
                .overlay(
                    RoundedRectangle(cornerRadius: style.radius)
                        .stroke(Color.accentColor, lineWidth: size.size.width*0.08)
                        .foregroundColor(.clear)
                        .frame(width: size.size.width*0.92, height: size.size.height*0.92)
                )
        } else {
            image
                .resizable()
                .scaledToFit()
                .frame(width: size.size.width, height: size.size.height)
        }
    }
}
