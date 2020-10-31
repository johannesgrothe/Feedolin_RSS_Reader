//
//  Model.swift
//  RSS_Reader
//
//  Created by Johannes Grothe on 31.10.20.
//

import Foundation

/**
 Model for the app, contains every information the views are using
 */
struct Model {
    var data: [ArticleData]
}

/**
 Dataset for used by the model to store article information loaded from the database or fetched from the network
 */
struct ArticleData: Identifiable {
    let id = UUID()
    let title: String
    let description: String
}

var model = Model(data: [
    ArticleData(title: "Yolo", description: "desc"),
    ArticleData(title: "Blubbb", description: "desc"),
    ArticleData(title: "xDDD", description: "desc")
])

