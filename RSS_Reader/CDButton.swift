//
//  CDButton.swift
//  RSS_Reader
//
//  Created by Kenanja Nuding on 1/27/21.
//

import SwiftUI

/// simpel Create-Delete Button shows in case true the minus-label and in case false the plus-label
struct CDButton: View {
    var action: () -> Void
    var exits: Bool
    var body: some View {
        Button(action: {
            action()
        }, label: {
            if (exits) {
                Image(systemName: "minus.circle.fill")
                    .foregroundColor(.red)
            } else {
                Image(systemName: "plus.circle.fill")
                    .foregroundColor(.green)
            }
        })
        .buttonStyle(BorderlessButtonStyle())
    }
}
