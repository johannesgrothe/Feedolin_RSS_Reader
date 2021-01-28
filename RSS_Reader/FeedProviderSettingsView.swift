//
//  FeedProviderSettingsView.swift
//  RSS_Reader
//
//  Created by Johannes Grothe on 07.11.20.
//

import SwiftUI

/**
 A view to let the user edit feed provider settings
 */
struct FeedProviderSettingsView: View {
    
    /**
     @feed_provider is the NewsFeedProvider to be editing
     */
    @ObservedObject var feed_provider: NewsFeedProvider
    /**
     @name is a string that holds the input of the user
     */
    @State private var name = ""
    /**
     @abbreviation also token or short_name is a string that holds the input of the user
     */
    @State private var abbreviation = ""
    /**
     @isEditing is the indicator if the user is editing the textfield
     */
    @State private var isEditing: Bool = false
    /**
     @presentationMode make the View dismiss itself
     */
    @Environment(\.presentationMode) var presentationMode
    /// IconStyle that indicates the style of every icon
    @AppStorage("image_style_int") var image_style_int: Int = ImageStyle.square_rounded.rawValue
    /// IconSize that indicates the size of every icon
    @AppStorage("image_size_int") var image_size_int: Int = ImageSize.medium.rawValue
    
    var body: some View {
        // hole content
        VStack(spacing: 30)  {
            // image and change-button
            ZStack{
                // image of provider
                CustomImage(image: feed_provider.icon.img, style: ImageStyle.init(rawValue: image_style_int)!, size: .xxxlarge)
                /* Not used right now 
                // change image button
                Button(action: {
                    print("change image pressed")
                }, label: {
                    CustomIcon(icon: .edit, style: ImageStyle.init(rawValue: image_style_int)!, size: image_size)
                })
                .background(Color("BackgroundColor"))
                .foregroundColor(Color("ButtonColor"))
                .cornerRadius(image_style_int == 0 ? 0 : ImageStyle.init(rawValue: image_style_int)!.radius)
                .offset(x: image_size.size.width, y: image_size.size.height)
                */
                
            }
            .frame(width: 100, height: 100, alignment: .center)
            .padding(.horizontal)
            
            // row with original url
            HStack{
                Text("URL")
                Spacer()
                Text(feed_provider.url)
                    .font(.subheadline)
            }
            .padding(.horizontal)
            
            // row with name and textfield
            HStack {
                Text("Name")
                    .padding(.trailing)
                // input textfield
                CustomTextfield(placholder: feed_provider.name,
                                text: $name,
                                on_commit: {
                                    feed_provider.name = self.name
                                    self.name = ""
                                })
            }
            .padding(.horizontal)
            
            // row with abbreviation and textfield
            HStack {
                Text("Abbreviation")
                    .padding(.trailing)
                // input textfield
                CustomTextfield(placholder: feed_provider.token,
                                text: $abbreviation,
                                on_commit: {
                                    feed_provider.token = self.abbreviation
                                    self.abbreviation = ""
                                })
            }
            .padding(.horizontal)
            
            Spacer()
        }
        .padding(.top)
        .defaultScreenLayout()
        .navigationBarTitle(feed_provider.name, displayMode: .inline)
        .onDisappear(perform: {
            if self.name != "" {
                feed_provider.name = self.name
            }
            if self.abbreviation != "" {
                feed_provider.token = self.abbreviation
            }
        })
    }
}

struct FeedProviderSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        FeedProviderSettingsView(feed_provider: NewsFeedProvider(url: "test.de", name: "TestProvider", token: "TP", icon_url: "blub/x.jpg", feeds: []))
    }
}
