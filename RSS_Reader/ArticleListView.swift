//
//  ArticleListView.swift
//  RSS_Reader
//
//  Created by Johannes Grothe on 31.10.20.
//

import SwiftUI

struct ArticleListView: View {
    var body: some View {
        List(model.data) {
            dataSet in ListEntryView(title: dataSet.title)
        }
        
//        List {
//            NavigationLink(destination: ArticleView()) {
//                ListEntryView(title: "Entry 1")
//            }
//            .navigationBarTitle("Master view")
//
//            NavigationLink(destination: ArticleView()) {
//                ListEntryView(title: "Entry 2")
//            }
//            .navigationBarTitle("Master view")
//
//            NavigationLink(destination: ArticleView()) {
//                ListEntryView(title: "Entry 3")
//            }
//            .navigationBarTitle("Master view")
//        }
    }
}

struct ArticleListView_Previews: PreviewProvider {
    static var previews: some View {
        ArticleListView()
    }
}
