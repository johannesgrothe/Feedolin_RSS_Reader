//
//  ArticleListView.swift
//  RSS_Reader
//
//  Created by Johannes Grothe on 31.10.20.
//

import SwiftUI

struct ArticleListView: View {
    var body: some View {
        List(model.article_data) {
            dataSet in ListEntryView(title: dataSet.title)
        }
    }
}

struct ArticleListView_Previews: PreviewProvider {
    static var previews: some View {
        ArticleListView()
    }
}
