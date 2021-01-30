//
//  ECButton.swift
//  RSS_Reader
//
//  Created by Kenanja Nuding on 1/27/21.
//

import SwiftUI

/// simpel Edit-Check Button shows in case true the check-label and in case false the edit-label
struct ECButton: View {
    /// the action that th button calls after click
    var action: () -> Void
    /// binding indicator to a boolean that show if its in edit mode or not
    @Binding var is_editing: Bool
    /// IconStyle that indicates the style of every icon
    @AppStorage("image_style_int") var image_style_int: Int = ImageStyle.square_rounded.rawValue
    /// IconSize that indicates the size of every icon
    @AppStorage("image_size_int") var image_size_int: Int = ImageSize.medium.rawValue
    
    var body: some View {
        Button(action: {
            is_editing.toggle()
            action()
        }, label: {
            if (is_editing) {
                Text("done_btn_title".localized).font(.headline)
//                CustomSystemImage(image: .check, style: ImageStyle.init(rawValue: image_style_int)!, size: ImageSize.init(rawValue: image_size_int)!)
            } else {
                Text("edit_btn_title".localized).font(.headline)
//                CustomSystemImage(image: .edit, style: ImageStyle.init(rawValue: image_style_int)!, size: ImageSize.init(rawValue: image_size_int)!)
            }
        })
        .buttonStyle(BorderlessButtonStyle())
    }
}
