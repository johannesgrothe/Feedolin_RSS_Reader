//
//  ECButton.swift
//  RSS_Reader
//
//  Created by Kenanja Nuding on 1/27/21.
//

import SwiftUI

/// simpel Edit-Check Button shows in case true the check-label and in case false the edit-label
struct ECButton: View {
    var action: () -> Void
    @Binding var is_editing: Bool
    var body: some View {
        Button(action: {
            is_editing.toggle()
            action()
        }, label: {
            if (is_editing) {
                Image(systemName: "checkmark.circle").imageScale(.large)
            } else {
                Image(systemName: "pencil.circle").imageScale(.large)
            }
        })
        .buttonStyle(BorderlessButtonStyle())
    }
}
