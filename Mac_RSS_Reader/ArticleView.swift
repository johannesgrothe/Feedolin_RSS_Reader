//
//  ArticleView.swift
//  Mac_RSS_Reader
//
//  Created by Emircan Duman on 08.01.21.
//

import Foundation
import SwiftUI

struct ArticleView: View {
    
    // the complete article in the view
    let article: ArticleData
    
    var body: some View {
        VStack{
            DummyDetailView()
                .onDisappear {
                    article.read = true
                }
        }
        .edgesIgnoringSafeArea([.bottom, .top])
    }
}
