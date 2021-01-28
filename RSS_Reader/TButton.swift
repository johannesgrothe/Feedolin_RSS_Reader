//
//  TButton.swift
//  RSS_Reader
//
//  Created by Kenanja Nuding on 1/28/21.
//

import SwiftUI

/// simpel Toggle Button shows to different Images
struct TButton: View {
    ///
    var action: () -> Void
    ///
    var image_one: SystemImage
    ///
    var image_two: SystemImage
    ///
    @Binding var bool: Bool
    
    var body: some View {
        Button(action: {
            bool.toggle()
            action()
        }, label: {
            if (bool) {
                CustomSystemImage(image: image_one, style: .nothing, size: .xsmall)
            } else {
                CustomSystemImage(image: image_two, style: .nothing, size: .xsmall)
            }
        })
        .buttonStyle(BorderlessButtonStyle())
    }
}
