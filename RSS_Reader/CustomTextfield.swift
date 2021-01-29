//
//  CustomTextfield.swift
//  RSS_Reader
//
//  Created by Kenanja Nuding on 1/28/21.
//

import SwiftUI

/// A Customizable Textfield
struct CustomTextfield: View {
    /// optinal image that is shown in leading position
    var image: SystemImage?
    /// the placholdertext of the textfield
    var placholder: String = ""
    /// the binding text of the textfield
    @Binding var text: String
    /// the action that is called after the enter-key is clicked
    var on_commit: () -> Void
    /// a private boolean that indcates if the textfield is in editing mode
    @State private var is_editing: Bool = false
    
    var body: some View {
        HStack {
            if image != nil {
                CustomSystemImage(image: image!, style: .nothing, size: .xsmall)
            }
            
            TextField(placholder,
                      text: $text,
                      onEditingChanged: { is_editing in
                        self.is_editing = is_editing
                      }, onCommit: {
                        if self.text != "" {
                            on_commit()
                        }
                      })
            
            Button(action: {
                self.text = ""
            }) {
                CustomSystemImage(image: .xmark, style: .nothing, size: .xsmall)
                    .opacity(self.text == "" ? 0 : 1)
            }
            .buttonStyle(BorderlessButtonStyle())
        }
        .padding(10)
        .foregroundColor(.secondary)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(10)
    }
}
