//
//  DefaultListEntryView.swift
//  RSS_Reader
//
//  Created by Kenanja Nuding on 1/22/21.
//

import SwiftUI

/// View that presents a default list entry
struct DefaultListEntryView: View {
    /// exact CustomImage
    var image: CustomImage?
    /// excact CustomIcon
    var icon: CustomIcon?
    /// padding around image
    var padding: CGFloat = 0
    /// text
    var text: String
    /// font of text
    var font: Font
    
    var body: some View {
        HStack {
            if image != nil {
                image!
                    .padding(padding)
            } else if icon != nil {
                icon!
                    .padding(padding)
                
            }
            
            Text(text)
                .font(font)
        }
    }
}


