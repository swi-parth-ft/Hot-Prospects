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
    @State private var backgroundColor = Color.red
    let possibleNumbers = 1...60
    var results: String {
        let selected = possibleNumbers.random(7).sorted()
        let strings = selected.map(String.init)
        return strings.formatted()
    }
    
    var body: some View {
        VStack {
            Text(results)
        }
         
    }
    
   
}

#Preview {
    ContentView()
}
