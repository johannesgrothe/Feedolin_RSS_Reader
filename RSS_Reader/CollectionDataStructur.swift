//
//  CollectionDataStructur.swift
//  RSS_Reader
//
//  Created by Katharina Kühn on 18.11.20.
//

import SwiftUI

/**
 Groups feeds
 */
class Collection: Identifiable, ObservableObject, Codable{
    
    /**
     Listing all the properties we want to serialize. The case's in the enum are the json propertys(left side) for example "id":"value", "name":"value"...
     */
    enum CodingKeys: CodingKey {
        case id, name, feed_id_list
    }
    
    /**
     Encode function to serialize a instance of Collection to a json string, writes out all the properties attached to their respective key
     */
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(feed_id_list, forKey: .feed_id_list)
    }
    
    /**
     Decoding constructor to deserialize the archived json data into a instance of Collection
     */
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(UUID.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        feed_list = []
        feed_id_list = try container.decode([UUID].self, forKey: .feed_id_list)
    }
    
    init(name: String, feed_list: [NewsFeed], feed_id_list: [UUID]) {
        self.name = name
        self.feed_list = feed_list
        self.id = UUID.init()
        self.feed_id_list = feed_id_list
    }
    
    /**
     Initialized a Collection
     - Parameter name The name of the collection.
     */
    init(name: String) {
        self.name = name
        self.feed_list = []
        self.id = UUID.init()
        self.feed_id_list = []
    }
    
    /**Unique id belong to the instance of a Collection*/
    let id: UUID
    
    /**
    Name of the collection
     */
    @Published var name: String
    
    /**
     List of the feeds belong to the collection
     */
    @Published var feed_list: [NewsFeed]
    
    /**
     List of the feeds ids belong to the collection
     */
    var feed_id_list: [UUID]
}
