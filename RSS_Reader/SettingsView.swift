//
//  SettingsView.swift
//  RSS_Reader
//
//  Created by Johannes Grothe on 04.11.20.
//

import SwiftUI

struct SettingsView: View {
    /**Model singleton*/
    @ObservedObject var model: Model = .shared
    
    /**Boolean that shows an alert if true*/
    @State private var showing_alert = false
    
    /**Boolean that show if aurto_refresh is on and saves at coredata*/
    @AppStorage("auto_refresh") private var auto_refresh: Bool = true
    
    /**
     * Indicates which color scheme is selected by the user
     */
    @AppStorage("dark_mode_enabled") var dark_mode_enabled: Int = 0
    
    var body: some View {
        List {
            /** Calling FeedSettingsView()*/
            NavigationLink(destination: FeedSettingsView()) {
                HStack {
                    Image(systemName: "newspaper").imageScale(.large)
                    Text("Feed Settings").font(.headline)
                }
            }
            .listRowBackground(Color.clear)
            
            /**Calling CollectionSettingsView()*/
            NavigationLink(destination: CollectionSettingsView()) {
                HStack {
                    Image(systemName: "folder").imageScale(.large)
                    Text("Collection Settings").font(.headline)
                }
            }
            .listRowBackground(Color.clear)
            
            /**ToggleButton that toogles the value of @auto_refresh*/
            HStack{
                Toggle(isOn: $auto_refresh){
                    Image(systemName: "arrow.clockwise").imageScale(.large)
                    Text("Auto Refresh").font(.headline)
                }
                .onChange(of: auto_refresh){ _ in
                    model.runAutoRefresh()
                }
            }
            .listRowBackground(Color.clear)
            
            // Picker to select if the App apears in light/ dark mode or system behaviour
            HStack {
                Image(systemName: "paintpalette").imageScale(.large)
                Text("Theme").font(.headline)
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

            //Picker mit icon links daneben und andere variante mit theme
            
            Button(action: {
                self.showing_alert = true
            }) {
                HStack{
                    //For the Reviwer an alternative image could be "trash"
                    Image(systemName: "doc.badge.gearshape").imageScale(.large)
                    Text("Reset App").font(.headline)
                }
            }
            .alert(isPresented: $showing_alert) {
                Alert(title: Text("App Reset"), message: Text("WARNING: This action will irreversible delete all Data!"), primaryButton: .default(Text("Okay"), action: {model.reset()}),secondaryButton: .cancel())
            }
            .listRowBackground(Color.clear)
        }
        .onAppear(perform: {
            UITableView.appearance().backgroundColor = .clear
            UITableViewCell.appearance().backgroundColor = .clear
            overrideColorScheme(theme_index: dark_mode_enabled)
        })
        .listStyle(PlainListStyle())
        .navigationBarTitle("settings_title".localized, displayMode: .inline)
        .background(Color("BackgroundColor"))
        .edgesIgnoringSafeArea(.bottom)
        
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
