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
        VStack {
            Text("Hello, world!")
                .padding()
                .background(backgroundColor)
            
            Text("Change Color")
                .padding()
                .contextMenu {
                    Button("Red", systemImage: "checkmark.circle.fill", role: .destructive) {
                        backgroundColor = .red
                    }
                    
                    Button("Blue") {
                        backgroundColor = .blue
                    }
                    
                    Button("Green") {
                        backgroundColor = .green
                    }
                }
        }
         
    }
    
   
}

#Preview {
    ContentView()
}
