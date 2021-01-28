//
//  CustomTextfield.swift
//  RSS_Reader
//
//  Created by Kenanja Nuding on 1/28/21.
//

import SwiftUI

///
struct CustomTextfield: View {
    ///
    var image: SystemImage?
    ///
    var placholder: String = ""
    ///
    @Binding var text: String
    ///
    var on_commit: () -> Void
    ///
    var button: AnyView?
    ///
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
            
            if button != nil {
                button
            }
        }
        .padding(10)
        .foregroundColor(.secondary)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(10)
    }
}
