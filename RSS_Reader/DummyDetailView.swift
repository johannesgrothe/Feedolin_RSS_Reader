//
//  DummyDetailView.swift
//  RSS_Reader
//
//  Created by Johannes Grothe on 31.10.20.
//

import SwiftUI

/**
 Dummy View to represent an settings view not yet implemented
 */
struct DummyDetailView: View {
    var body: some View {
        VStack{
            Spacer()
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            Spacer()
        }
        .background(Color(UIColor(named: "BackgroundColor")!))
        .edgesIgnoringSafeArea(.bottom)
    }
}

struct DummyDetailView_Previews: PreviewProvider {
    static var previews: some View {
        DummyDetailView()
    }
}
