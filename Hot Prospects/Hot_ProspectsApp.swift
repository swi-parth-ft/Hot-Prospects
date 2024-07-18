//
//  Hot_ProspectsApp.swift
//  Hot Prospects
//
//  Created by Parth Antala on 2024-07-18.
//

import SwiftUI
import SwiftData
@main
struct Hot_ProspectsApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Prospect.self)
    }
}
