//
//  EditProspect.swift
//  Hot Prospects
//
//  Created by Parth Antala on 2024-07-18.
//

import SwiftUI
import SwiftData

struct EditProspect: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    var prospect: Prospect
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var isContacted = false
    var body: some View {
        VStack {
        Form {
            Section("Update \(prospect.name)") {
                TextField("Name", text: $name)
                TextField("email", text: $email)
            }
            .listRowBackground(Color.white.opacity(0.5))
            Button("Save") {
                prospect.name = name
                prospect.email = email
                
                modelContext.delete(prospect)
                
                let newPerson = Prospect(name: name, email: email, isContacted: false)
                modelContext.insert(newPerson)
                dismiss()
            }
            .listRowBackground(Color.white.opacity(0.5))
            .tint(.orange)
        }
        .scrollContentBackground(.hidden)
        .onAppear {
            name = prospect.name
            email = prospect.email
            
        }
    }
        .background(LinearGradient(colors: [.orange, .white], startPoint: .top, endPoint: .bottom))
    }
}

#Preview {
    var privewProspect = Prospect(name: "Parth Antala", email: "parth.antala@example.com", isContacted: true)
    EditProspect(prospect: privewProspect)
}
