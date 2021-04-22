//
//  WaitingButton.swift
//  RSS_Reader
//
//  Created by Kenanja Nuding on 4/15/21.
//

import Combine
import SwiftUI

/// Button that show ProgressView while waiting for  the action to complete
struct WaitingButton: View {
    @State private var is_refreshing: Bool = false
    
    /// the action that th button calls after click
    var action: () -> Void
    
    var publisher: Published<Bool>.Publisher
    
    var body: some View {
        ZStack {
            Button(action: {
                action()
            }, label: {
                CustomSystemImage(image: .option_auto_refresh, color: .button)
            })
            .opacity(is_refreshing ? 0 : 1)
            ProgressView()
                .opacity(is_refreshing ? 1 : 0)
        }
        .onReceive(publisher) {
            is_refreshing = $0
        }
    }
}


