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
                CustomSystemImage(image: .minus, style: .nothing, size: .xsmall, color: .red)
            } else {
                CustomSystemImage(image: .plus, style: .nothing, size: .xsmall, color: .green)
            }
        })
        .buttonStyle(BorderlessButtonStyle())
    }
}
