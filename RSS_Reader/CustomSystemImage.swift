//
//  CustomIcon.swift
//  RSS_Reader
//
//  Created by Kenanja Nuding on 1/27/21.
//

import SwiftUI

struct CustomSystemImage: View {
    var image: SystemImage
    var style: ImageStyle
    var size: ImageSize
    var color: Color = Color.accentColor
    
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
            image.image
                .resizable()
                .scaledToFit()
                .frame(width: size.size.width, height: size.size.width)
                .foregroundColor(color)
        }
    }
}
