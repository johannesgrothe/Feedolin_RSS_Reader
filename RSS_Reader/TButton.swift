//
//  TButton.swift
//  RSS_Reader
//
//  Created by Kenanja Nuding on 1/28/21.
//

import SwiftUI

/// simpel Toggle Button shows to different Images
struct TButton: View {
    /// the action that th button calls after click
    var action: () -> Void
    /// the first image that is shown
    var image_one: SystemImage
    /// the second image that is shown
    var image_two: SystemImage
    /// binding to a boolean to know which image to show
    @Binding var bool: Bool
    
    var body: some View {
        Button(action: {
            bool.toggle()
            action()
        }, label: {
            if (bool) {
                CustomSystemImage(image: image_one, style: .nothing, size: .medium)
            } else {
                CustomSystemImage(image: image_two, style: .nothing, size: .medium)
            }
        })
        .buttonStyle(BorderlessButtonStyle())
    }
}
