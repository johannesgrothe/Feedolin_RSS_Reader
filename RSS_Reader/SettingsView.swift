//
//  SettingsView.swift
//  RSS_Reader
//
//  Created by Johannes Grothe on 04.11.20.
//

import SwiftUI

struct SettingsView: View {
    /// Model singleton
    @ObservedObject var model: Model = .shared
    /// Boolean that shows an alert if true
    @State private var showing_alert = false
    /// Boolean that show if aurto_refresh is on and saves at coredata
    @AppStorage("auto_refresh") var auto_refresh: Bool = true
    /// Indicates which color scheme is selected by the user
    @AppStorage("dark_mode_enabled") var dark_mode_enabled: Int = 0
    /// IconStyle that indicates the style of every icon
    @AppStorage("image_style_int") var image_style_int: Int = ImageStyle.square_rounded.rawValue
    /// IconSize that indicates the size of every icon
    @AppStorage("image_size_int") var image_size_int: Int = ImageSize.medium.rawValue
    
    @State private var isEditing = false
    @State private var size = 3.0
    
    var body: some View {
        List {
            Section {
                /** Calling FeedSettingsView()*/
                NavigationLink(destination: FeedSettingsView()) {
                    DefaultListEntryView(sys_image: CustomSystemImage(image: .feed_settings, style: ImageStyle.init(rawValue: image_style_int)!, size: ImageSize.init(rawValue: image_size_int)!), text: "Feed Settings", font: .headline)
                }
                .listRowBackground(Color.clear)
                
                /**Calling CollectionSettingsView()*/
                NavigationLink(destination: CollectionSettingsView()) {
                    DefaultListEntryView(sys_image: CustomSystemImage(image: .collection_settings, style: ImageStyle.init(rawValue: image_style_int)!, size: ImageSize.init(rawValue: image_size_int)!), text: "Collection Settings", font: .headline)
                }
                .listRowBackground(Color.clear)
            }
            
            Section {
                /**ToggleButton that toogles the value of @auto_refresh*/
                HStack{
                    Toggle(isOn: $auto_refresh){
                        DefaultListEntryView(sys_image: CustomSystemImage(image: .auto_refresh, style: ImageStyle.init(rawValue: image_style_int)!, size: ImageSize.init(rawValue: image_size_int)!),text: "Auto Refresh", font: .headline)
                    }
                    .onChange(of: auto_refresh){ _ in
                        model.runAutoRefresh()
                    }
                }
                .listRowBackground(Color.clear)
            }
            
            Section {
                /// Picker to select if the App apears in light/ dark mode or system behaviour
                HStack {
                    CustomSystemImage(image: .theme, style: ImageStyle.init(rawValue: image_style_int)!, size: ImageSize.init(rawValue: image_size_int)!)
                    Picker("Theme", selection: $dark_mode_enabled) {
                        Text("System").tag(0)
                        Text("Light").tag(1)
                        Text("Dark").tag(2)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .onReceive([self.dark_mode_enabled].publisher.first()) { _ in
                        overrideColorScheme(theme_index: dark_mode_enabled)
                    }
                }
                .listRowBackground(Color.clear)
                /// Picker to choose the image style
                HStack{
                    CustomSystemImage(image: .image_style, style: ImageStyle.init(rawValue: image_style_int)!, size: ImageSize.init(rawValue: image_size_int)!)
                    Picker("Image Style", selection: $image_style_int) {
                        CustomSystemImage(image: .square_dashed, style: ImageStyle.init(rawValue: image_style_int)!, size: ImageSize.init(rawValue: image_size_int)!).tag(0)
                        CustomSystemImage(image: .square, style: ImageStyle.init(rawValue: image_style_int)!, size: ImageSize.init(rawValue: image_size_int)!).tag(1)
                        CustomSystemImage(image: .square_rounded, style: ImageStyle.init(rawValue: image_style_int)!, size: ImageSize.init(rawValue: image_size_int)!).tag(2)
                        CustomSystemImage(image: .circle, style: ImageStyle.init(rawValue: image_style_int)!, size: ImageSize.init(rawValue: image_size_int)!).tag(3)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                .listRowBackground(Color.clear)
                
                /// Slider to choose the image size
                HStack {
                    DefaultListEntryView(sys_image: CustomSystemImage(image: .icon_size, style: ImageStyle.init(rawValue: image_style_int)!, size: ImageSize.init(rawValue: image_size_int)!), text: "Icon Size", font: .headline)
                    Slider(value: $size,
                           in: 2...4, step: 1,
                           onEditingChanged: { editing in
                           isEditing = editing
                            image_size_int = Int(size)
                       }
                   )
                }
                .listRowBackground(Color.clear)
            }
            
            Section {
                Button(action: {
                    self.showing_alert = true
                }) {
                    DefaultListEntryView(sys_image: CustomSystemImage(image: .trash, style: ImageStyle.init(rawValue: image_style_int)!, size: ImageSize.init(rawValue: image_size_int)!), text: "Reset App", font: .headline)
                }
                .alert(isPresented: $showing_alert) {
                    Alert(title: Text("App Reset"), message: Text("WARNING: This action will irreversible delete all Data!"), primaryButton: .default(Text("Okay"), action: {model.reset()}),secondaryButton: .cancel())
                }
                .listRowBackground(Color.clear)
            }
        }
        .listStyle(GroupedListStyle())
        .navigationBarTitle("Settings", displayMode: .inline)
        .defaultScreenLayout()
        .onAppear(perform: {
            size = Double(image_size_int)
        })
    }
}

/// Sets the color scheme of the app to light/ dark mode or system preferences
func overrideColorScheme(theme_index: Int) {
    var userInterfaceStyle: UIUserInterfaceStyle
    
    switch theme_index {
    case 1: userInterfaceStyle = .light
    case 2: userInterfaceStyle = .dark
    default : userInterfaceStyle = .unspecified
    }
    
    UIApplication.shared.windows.first?.overrideUserInterfaceStyle = userInterfaceStyle
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
