//
//  DataStructures.swift
//  RSS_Reader
//
//  Created by Johannes Grothe on 31.10.20.
//

import Foundation

/**
 Dataset for used by the model to store article information loaded from the database or fetched from the network
 */
struct ArticleData: Identifiable {
    let id = UUID()
    let article_id: String
    let title: String
    let description: String
    let link: String
    let src_feed: UUID
    let pub_date: Date
    let author: String?
}
