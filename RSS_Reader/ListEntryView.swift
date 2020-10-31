//
//  ListEntryView.swift
//  RSS_Reader
//
//  Created by Johannes Grothe on 31.10.20.
//

import SwiftUI

struct ListEntryView: View {
    
    let title: String
    
    var body: some View {
        Text(title)
    }
}

struct ListEntryView_Previews: PreviewProvider {
    static var previews: some View {
        ListEntryView(title: "testentry")
    }
}
