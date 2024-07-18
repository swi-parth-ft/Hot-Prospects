//
//  ContentView.swift
//  Hot Prospects
//
//  Created by Parth Antala on 2024-07-18.
//

import SwiftUI

struct ContentView: View {
    
    let users = ["Tohru", "Yuki", "Kyo", "Momiji"]
    @State private var selection = Set<String>()
    
    var body: some View {
        List(users, id: \.self, selection: $selection) { user in
            Text(user)
        }
        
        if !selection.isEmpty {
            Text("You Selected \(selection.formatted())")
        }
        
        EditButton()
    }
}

#Preview {
    ContentView()
}
