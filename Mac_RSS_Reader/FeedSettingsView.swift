//
//  FeedSettingsView.swift
//  Mac_RSS_Reader
//
//  Created by Emircan Duman on 18.01.21.
//

import SwiftUI

/**
 A view to let the user edit feed provider settings
 */
struct FeedSettingsView: View {
    
    @ObservedObject var model: Model = .shared
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            List{
                ForEach(model.feed_data){feed_provider in
                    NavigationLink(destination: FeedProviderSettingsView(feed_provider: feed_provider)){
                        HStack{
                            feed_provider.icon.img
                                .resizable()
                                .scaledToFit()
                                .frame(width: 25, height: 25)
                                .foregroundColor(.red)
                            
                            Text(feed_provider.name)
                            
                            Spacer()
                        }
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .listRowBackground(Color.clear)
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    ForEach(feed_provider.feeds){ feed in
                        NavigationLink(destination:FeedEditSettingsView(feed: feed)){
                            Text(feed.name)
                                .font(.headline)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.leading)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
            .listStyle(SidebarListStyle())
        }
    }
}

struct FeedSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        FeedSettingsView()
    }
}
