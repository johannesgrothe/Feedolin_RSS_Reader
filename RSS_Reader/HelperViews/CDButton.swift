//
//  CDButton.swift
//  RSS_Reader
//
//  Created by Kenanja Nuding on 1/27/21.
//

import SwiftUI

/// simpel Create-Delete Button shows in case true the minus-label and in case false the plus-label
struct CDButton: View {
    /// the action that th button calls after click
    var action: () -> Void
    /// an indicator boolean that shows if the element is to creat or delete
    var exits: Bool
    
    var body: some View {
        Button(action: {
            action()
        }, label: {
            if (exits) {
                CustomSystemImage(image: .minus, style: .nothing, size: .medium, color: .red)
            } else {
                CustomSystemImage(image: .plus, style: .nothing, size: .medium, color: .green)
            }
        })
        .buttonStyle(BorderlessButtonStyle())
    }
}
