//
//  ContentView.swift
//  Hot Prospects
//
//  Created by Parth Antala on 2024-07-18.
//

import UserNotifications
import SwiftUI
import SamplePackage

struct ContentView: View {
    
    var body: some View {
        TabView {
            ProspectsView(filter: .none)
                .tabItem {
                    Label("Everyone", systemImage: "person.3")
                }
            
            ProspectsView(filter: .contacted)
                .tabItem {
                    Label("Contacted", systemImage: "checkmark.circle")
                }
            
            ProspectsView(filter: .uncontacted)
                .tabItem {
                    Label("Uncontacted", systemImage: "questionmark.diamond")
                }
            
            MeView()
                .tabItem {
                    Label("Me", systemImage: "person.crop.square")
                }
        }
         
    }
    
   
}

#Preview {
    ContentView()
}
