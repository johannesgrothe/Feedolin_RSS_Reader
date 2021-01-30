//
//  GeneralSettingsView.swift
//  Mac_RSS_Reader
//
//  Created by Emircan Duman on 30.01.21.
//

import SwiftUI

struct GeneralSettingsView: View{
    
    @State private var showingAlert = false
    
    /**Boolean that show if aurto_refresh is on and saves at coredata*/
    @AppStorage("auto_refresh") private var auto_refresh: Bool = true
    
    var body: some View{
        HStack{
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
        Spacer()
        }
    }
}

struct GeneralSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        GeneralSettingsView()
    }
}
