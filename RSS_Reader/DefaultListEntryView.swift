//
//  DefaultListEntryView.swift
//  RSS_Reader
//
//  Created by Kenanja Nuding on 1/22/21.
//
import SwiftUI

/**
 View that presents a default list entry
 */
struct DefaultListEntryView: View {
    // exact image
    var image: Image?
    // imageCornerRadius
    var imageCornerRadius: CGFloat = 0
    // systemName of image
    var imageName: String = "chevron.right.circle"
    // image width and height
    var imageScale: CGFloat
    // padding around image
    var imagePadding: CGFloat = 0
    // text
    var text: String
    // font of text
    var font: Font
    
    var body: some View {
        HStack {
            if image != nil {
                image!
                    .resizable()
                    .scaledToFit()
                    .frame(width: imageScale, height: imageScale)
                    .padding(imagePadding)
                    .cornerRadius(imageCornerRadius)
                    .overlay(
                        RoundedRectangle(cornerRadius: imageCornerRadius)
                            .stroke(Color("ButtonColor"), lineWidth: imageScale*0.08)
                            .foregroundColor(.clear)
                            .frame(width: imageScale*0.92, height: imageScale*0.92)
                    )
            } else {
                Image(systemName: imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: imageScale, height: imageScale)
                    .padding(imagePadding)
                    .cornerRadius(imageCornerRadius)
                    .foregroundColor(Color("ButtonColor"))
            }
            
            Text(text)
                .font(font)
        }
    }
}


