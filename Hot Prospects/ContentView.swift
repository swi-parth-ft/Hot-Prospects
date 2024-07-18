//
//  ContentView.swift
//  Hot Prospects
//
//  Created by Parth Antala on 2024-07-18.
//

import SwiftUI

struct ContentView: View {
    @State private var backgroundColor = Color.red
    
    var body: some View {
        List {
            Text("Elvis")
                .swipeActions(edge: .leading) {
                    Button("Send Message", systemImage: "message") {
                        print("Hello")
                    }
                    .tint(.orange)
                }
            
                .swipeActions {
                    Button("Delete", systemImage: "minus.circle", role: .destructive) {
                        print("Deleting")
                    }
                }
        }
         
    }
    
   
}

#Preview {
    ContentView()
}
