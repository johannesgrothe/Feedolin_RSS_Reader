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
    var sys_image: CustomSystemImage?
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
            } else if sys_image != nil {
                sys_image!
                    .padding(padding)
            }
            
            Text(text)
                .font(font)
        }
    }
}


