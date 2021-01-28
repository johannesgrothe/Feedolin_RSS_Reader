//
//  CustomIcon.swift
//  RSS_Reader
//
//  Created by Kenanja Nuding on 1/27/21.
//

import SwiftUI

struct CustomIcon: View {
    var icon: SystemIcon
    var style: ImageStyle
    var size: IconSize
    var color: Color = Color.accentColor
    
    var body: some View {
        if style != .nothing {
            Image(systemName: icon.name)
                .resizable()
                .scaledToFit()
                .frame(width: size.width*0.5, height: size.width*0.5)
                .padding(7)
                .cornerRadius(style.radius)
                .overlay(
                    RoundedRectangle(cornerRadius: style.radius)
                        .stroke(color, lineWidth: size.width*0.08)
                        .frame(width: size.width*0.92, height: size.width*0.92)
                )
                .frame(width: size.size.width, height: size.size.height)
                .foregroundColor(color)
        } else {
            Image(systemName: icon.name)
                .resizable()
                .scaledToFit()
                .frame(width: size.width, height: size.width)
                .foregroundColor(color)
        }
    }
}
