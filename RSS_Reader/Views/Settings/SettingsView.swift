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
    @AppStorage("image_style_int") var image_style_int: Int = ImageStyle.nothing.rawValue
    /// IconSize that indicates the size of every icon
    @AppStorage("image_size_int") var image_size_int: Int = ImageSize.small.rawValue
    /*
     @State private var isEditing = false
     @State private var size = 3.0
     */
    var body: some View {
        List {
            Section {
                /** Calling FeedSettingsView()*/
                NavigationLink(destination: FeedSettingsView()) {
                    DefaultListEntryView(
                        sys_image: CustomSystemImage(image: .feed_settings),
                        text: "feed_settings_title".localized,
                        font: .headline)
                }
                
                /**Calling CollectionSettingsView()*/
                NavigationLink(destination: CollectionSettingsView()) {
                    DefaultListEntryView(
                        sys_image: CustomSystemImage(image: .collection_settings),
                        text: "coll_settings_title".localized,
                        font: .headline)
                }
            }
            .listRowBackground(Color.article)
            Section {
                /**ToggleButton that toogles the value of @auto_refresh*/
                HStack{
                    Toggle(isOn: $auto_refresh){
                        DefaultListEntryView(
                            sys_image: CustomSystemImage(image: .option_auto_refresh),
                            text: "auto_refresh_option".localized,
                            font: .headline)
                    }
                    .onChange(of: auto_refresh){ _ in
                        model.runAutoRefresh()
                    }
                }
                
                /// Picker to select if the App apears in light/ dark mode or system behaviour
                HStack {
                    CustomSystemImage(image: .option_theme)
                    Picker("theme_option".localized, selection: $dark_mode_enabled) {
                        Text("theme_system".localized).tag(0)
                        Text("theme_light".localized).tag(1)
                        Text("theme_dark".localized).tag(2)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .onReceive([self.dark_mode_enabled].publisher.first()) { _ in
                        overrideColorScheme(theme_index: dark_mode_enabled)
                    }
                }
            }
            .listRowBackground(Color.article)
            /*
             Section {
             
             
             /// Picker to choose the image style
             HStack{
             CustomSystemImage(image: .option_image_style, style: ImageStyle.init(rawValue: image_style_int)!, size: ImageSize.init(rawValue: image_size_int)!)
             Picker("Image Style", selection: $image_style_int) {
             CustomSystemImage(image: .no_style, style: ImageStyle.init(rawValue: image_style_int)!, size: ImageSize.init(rawValue: image_size_int)!).tag(0)
             CustomSystemImage(image: .square_style, style: ImageStyle.init(rawValue: image_style_int)!, size: ImageSize.init(rawValue: image_size_int)!).tag(1)
             CustomSystemImage(image: .square_round_style, style: ImageStyle.init(rawValue: image_style_int)!, size: ImageSize.init(rawValue: image_size_int)!).tag(2)
             CustomSystemImage(image: .circle_style, style: ImageStyle.init(rawValue: image_style_int)!, size: ImageSize.init(rawValue: image_size_int)!).tag(3)
             }
             .pickerStyle(SegmentedPickerStyle())
             }
             
             /// Slider to choose the image size
             HStack {
             DefaultListEntryView(sys_image: CustomSystemImage(image: .option_icon_size, style: ImageStyle.init(rawValue: image_style_int)!, size: ImageSize.init(rawValue: image_size_int)!), text: "Icon Size", font: .headline)
             Slider(value: $size,
             in: 2...4, step: 1,
             onEditingChanged: { editing in
             isEditing = editing
             image_size_int = Int(size)
             }
             )
             }
             }
             .listRowBackground(Color.article)
             */
            Section {
                Button(action: {
                    self.showing_alert = true
                }) {
                    DefaultListEntryView(
                        sys_image: CustomSystemImage(image: .option_reset_app),
                        text: "reset_app_option".localized,
                        font: .headline)
                }
                .alert(isPresented: $showing_alert) {
                    Alert(
                        title: Text("app_reset_alert_title".localized),
                        message: Text("app_reset_alert_text".localized),
                        primaryButton: .default(Text("ok_btn_title".localized), action: {
                                                    model.reset()}),secondaryButton: .cancel())
                }
            }
            .listRowBackground(Color.article)
        }
        .listStyle(GroupedListStyle())
        .navigationBarTitle("settings_title".localized, displayMode: .inline)
        .defaultScreenLayout()
        /*
         .onAppear(perform: {
         size = Double(image_size_int)
         })
         */
    }
}

/// Sets the color scheme of the app to light/ dark mode or system preferences
func overrideColorScheme(theme_index: Int) {
    var userInterfaceStyle: UIUserInterfaceStyle
    
    switch theme_index {
    case 1: userInterfaceStyle = .light
    case 2: userInterfaceStyle = .dark
    default : userInterfaceStyle = UITraitCollection.current.userInterfaceStyle
    }
    
    UIApplication.shared.windows.first?.overrideUserInterfaceStyle = userInterfaceStyle
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}