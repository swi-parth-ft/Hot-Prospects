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
        Form {
            TextField("Name", text: $name)
            TextField("email", text: $email)
//            Toggle(isOn: $isContacted){
//                Text("Connected?")
//            }
            Button("Save") {
                prospect.name = name
                prospect.email = email
                
                modelContext.delete(prospect)
                
                let newPerson = Prospect(name: name, email: email, isContacted: false)
                modelContext.insert(newPerson)
                dismiss()
            }
        }
        .onAppear {
            name = prospect.name
            email = prospect.email
           
        }
    }
}

#Preview {
    var privewProspect = Prospect(name: "Parth Antala", email: "parth.antala@example.com", isContacted: true)
    EditProspect(prospect: privewProspect)
}
