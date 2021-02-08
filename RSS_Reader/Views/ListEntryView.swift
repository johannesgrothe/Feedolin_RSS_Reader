//
//  ListEntryView.swift
//  RSS_Reader
//
//  Created by Johannes Grothe on 31.10.20.
//

import SwiftUI

/**
 View that represets an article in the article list
 */
struct ListEntryView: View {
    
    let title: String
    
    var body: some View {
        NavigationLink(destination: DummyDetailView()) {
            Text(title)
        }
        .navigationBarTitle("Feed")
    }
}

struct ListEntryView_Previews: PreviewProvider {
    static var previews: some View {
        ListEntryView(title: "testentry")
    }
}
