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
    
    @State private var showingAlert = false
    
    private enum Tabs: Hashable {
        case feed_provider, collection, general
    }
    
    var body: some View {
        
        TabView {
            GeneralSettingsView()
                .tabItem{
                    Label("General Settings", systemImage: "gear")
                }
                .tag(Tabs.general)
            
            FeedSettingsView()
                .tabItem {
                    Label("Feed Settings", systemImage: "newspaper")
                }
                .tag(Tabs.feed_provider)
                
            CollectionSettingsView()
                .tabItem{
                    Label("Collection Settings", systemImage: "folder.badge.gear")
                }
                .tag(Tabs.collection)
        }
        .frame(minWidth:1000, minHeight: 500)
    }
}

struct GeneralSettingsView: View{
    
    @State private var showingAlert = false
    
    /**Boolean that show if aurto_refresh is on and saves at coredata*/
    @AppStorage("auto_refresh") private var auto_refresh: Bool = true
    
    var body: some View{
        Form{
            Button(action: {
                self.showingAlert = true
            }) {
                HStack{
                    //For the Reviwer an alternative image could be "trash"
                    Image(systemName: "doc.badge.gearshape").imageScale(.large)
                        .foregroundColor(Color.red)
                    Text("Reset App").font(.headline)
                        .foregroundColor(Color.red)
                }
            }
            .padding(.horizontal)
            .alert(isPresented: $showingAlert) {
                Alert(title: Text("App Reset"), message: Text("WARNING: This action will irreversible delete all Data!"), primaryButton: .default(Text("Okay"), action: {model.reset()}),secondaryButton: .cancel())
            }
            
            Toggle(isOn: $auto_refresh){
                Image(systemName: "arrow.clockwise").imageScale(.large)
                Text("Auto Refresh").font(.headline)
            }
            .onChange(of: auto_refresh){ _ in
                model.runAutoRefresh()
            }
            .padding(.horizontal)
            
            Spacer()
        }
        .padding(.top)
        .edgesIgnoringSafeArea(.bottom)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
