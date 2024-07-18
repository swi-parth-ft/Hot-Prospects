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
    @State private var output = ""
    
    var body: some View {
        Text(output)
            .task {
                await fetchReadings()
            }
    }
    
    func fetchReadings() async {
        let fetchTask = Task {
            let url = URL(string: "https://hws.dev/readings.json")!
            let (data, _) = try await URLSession.shared.data(from: url)
            let readings = try JSONDecoder().decode([Double].self, from: data)
            return "Found \(readings.count) readings"
        }
        
        let result =  await fetchTask.result
        
        switch result {
        case .success(let message):
            output = message
        case .failure(let error):
            output = "Error: \(error.localizedDescription)"
        }
        
    }
}

#Preview {
    ContentView()
}
