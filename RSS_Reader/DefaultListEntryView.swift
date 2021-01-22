//
//  DefaultListEntryView.swift
//  RSS_Reader
//
//  Created by Kenanja Nuding on 1/22/21.
//
import SwiftUI

/// View that presents a default list entry
struct DefaultListEntryView: View {
    /// exact image
    var image: Image?
    /// image_corner_radius
    var image_corner_radius: CGFloat = 0
    /// image_name of image
    var image_name: String = "chevron.right.circle"
    /// image width and height
    var image_scale: CGFloat
    /// padding around image
    var image_padding: CGFloat = 0
    /// text
    var text: String
    /// font of text
    var font: Font
    
    var body: some View {
        HStack {
            if image != nil {
                image!
                    .resizable()
                    .scaledToFit()
                    .frame(width: image_scale, height: image_scale)
                    .padding(image_padding)
                    .cornerRadius(image_corner_radius)
                    .overlay(
                        RoundedRectangle(cornerRadius: image_corner_radius)
                            .stroke(Color("ButtonColor"), lineWidth: image_scale*0.08)
                            .foregroundColor(.clear)
                            .frame(width: image_scale*0.92, height: image_scale*0.92)
                    )
            } else {
                Image(systemName: image_name)
                    .resizable()
                    .scaledToFit()
                    .frame(width: image_scale, height: image_scale)
                    .padding(image_padding)
                    .cornerRadius(image_corner_radius)
                    .foregroundColor(Color("ButtonColor"))
            }
            
            Text(text)
                .font(font)
        }
    }
}


