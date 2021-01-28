//
//  CustomImage.swift
//  RSS_Reader
//
//  Created by Kenanja Nuding on 1/27/21.
//

import SwiftUI

struct CustomImage: View {
    var image: Image
    var style: ImageStyle
    var size: IconSize
    var color: Color = Color.accentColor
    
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
