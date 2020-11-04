//
//  StoreData.swift
//  RSS_Reader
//
//  Created by Emircan Duman on 04.11.20.
//

import Combine
import SwiftUI

final class StoreData: ObservableObject {
    @Published var articles = articleData
}
