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
    @AppStorage("auto_refresh") private var auto_refresh: Bool = true
    /// scale of all icons
    let image_scale: CGFloat = 28
    
    /**
     * Indicates which color scheme is selected by the user
     */
    @AppStorage("dark_mode_enabled") var dark_mode_enabled: Int = 0
    
    var body: some View {
        List {
            /** Calling FeedSettingsView()*/
            NavigationLink(destination: FeedSettingsView()) {
                DefaultListEntryView(image_name: "wave.3.right.circle", image_scale: image_scale, text: "Feed Settings", font: .headline)
            }
            .listRowBackground(Color.clear)
            
            /**Calling CollectionSettingsView()*/
            NavigationLink(destination: CollectionSettingsView()) {
                DefaultListEntryView(image_name: "rectangle.fill.on.rectangle.fill.circle", image_scale: image_scale, text: "Collection Settings", font: .headline)
            }
            .listRowBackground(Color.clear)
            
            /**ToggleButton that toogles the value of @auto_refresh*/
            HStack{
                Toggle(isOn: $auto_refresh){
                    DefaultListEntryView(image_name: "arrow.clockwise.circle", image_scale: image_scale, text: "Auto Refresh", font: .headline)
                }
                .onChange(of: auto_refresh){ _ in
                    model.runAutoRefresh()
                }
            }
            .listRowBackground(Color.clear)
            
            // Picker to select if the App apears in light/ dark mode or system behaviour
            HStack {
                Image(systemName: "paintpalette").imageScale(.large)
                Text("theme_option".localized).font(.headline)
                Picker("Theme", selection: $dark_mode_enabled) {
                    Text("theme_system".localized).tag(0)
                    Text("theme_light".localized).tag(1)
                    Text("theme_dark".localized).tag(2)
                }
                .pickerStyle(SegmentedPickerStyle())
                .onReceive([self.dark_mode_enabled].publisher.first()) { _ in
                    overrideColorScheme(theme_index: dark_mode_enabled)
                            }
            }
            .listRowBackground(Color.clear)

            //Picker mit icon links daneben und andere variante mit theme
            
            Button(action: {
                self.showing_alert = true
            }) {
                DefaultListEntryView(image_name: "trash.circle", image_scale: image_scale, text: "Reset App", font: .headline)
            }
            .alert(isPresented: $showing_alert) {
                Alert(title: Text("app_reset_alert_title".localized),
                      message: Text(genAppResetWarning()),
                      primaryButton: .default(Text("ok_btn_title".localized),action: {model.reset()}),secondaryButton: .cancel())
            }
            .listRowBackground(Color.clear)
        }
        .listStyle(PlainListStyle())
        .navigationBarTitle("settings_title".localized, displayMode: .inline)
        .background(Color("BackgroundColor"))
        .defaultScreenLayout()
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
