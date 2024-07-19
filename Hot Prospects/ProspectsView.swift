//
//  ProspectsView.swift
//  Hot Prospects
//
//  Created by Parth Antala on 2024-07-18.
//
import SwiftData
import SwiftUI
import CodeScanner
import UserNotifications

struct ProspectsView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    
    @Query(sort: \Prospect.name) var prospects: [Prospect]
    @State private var isShowingScanner = false
    @State private var selectedProspects = Set<Prospect>()
    @State private var editing = false
    @State private var isShowingEdit = false
    @State private var prospectToEdit: Prospect?
    @State private var selectedHour = 9
    
    @State private var showingDatePicker = false
    @State private var selectedProspect: Prospect?
    @State private var reminderDate = Date()
    @State private var showComfirmation = false
    
    enum FilterType {
        case none, contacted, uncontacted
    }
    
    let filter: FilterType
    
    var title: String {
        switch filter {
        case .none:
            "Everyone"
        case .contacted:
            "Contacted people"
        case .uncontacted:
            "Uncontacted people"
        }
    }
    
    var body: some View {
        NavigationStack {
            List(prospects, selection: $selectedProspects) { prospect in
                HStack {
                    if filter == .none {
                        Circle()
                            .frame(width: 10, height: 10)
                            .foregroundColor(prospect.isContacted ? .green : .red)
                            .padding(.trailing)
                    }
                    
                    VStack(alignment: .leading) {
                        Text(prospect.name)
                            .font(.headline)
                        
                        Text(prospect.email)
                            .foregroundStyle(.secondary)
                        
                    }
                }
                .sheet(isPresented: $isShowingEdit) {
                    EditProspect(prospect: prospect)
                }
                
                .swipeActions(edge: .leading, allowsFullSwipe: true) {
                    Button("Edit", systemImage: "pencil") {
                        isShowingEdit = true
                    }
                    .tint(.blue)
                    
                    Picker("Alert hour", selection: $selectedHour) {
                        ForEach(0..<24) { number in
                            Text("\(number)")
                        }
                    }
                    .pickerStyle(.menu)
                }
                .swipeActions {
                    Button("Delete", systemImage: "trash", role: .destructive) {
                        modelContext.delete(prospect)
                    }
                    if prospect.isContacted {
                        Button("Mark Uncontacted", systemImage: "person.crop.circle.badge.xmark") {
                            prospect.isContacted.toggle()
                        }
                        .tint(.blue)
                    } else {
                        Button("Mark Contacted", systemImage: "person.crop.circle.fill.badge.checkmark") {
                            prospect.isContacted.toggle()
                        }
                        .tint(.green)
                        
                        Button("Remind Me", systemImage: "bell") {
                            selectedProspect = prospect
                            showingDatePicker = true
                            
                            //        addNotification(for: prospect)
                        }
                        .tint(.orange)
                    }
                }
                .tag(prospect)
                
                
            }
            .navigationTitle(title)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Scan", systemImage: "qrcode.viewfinder") {
                        isShowingScanner = true
                    }
                }
                
                ToolbarItem(placement: .topBarLeading) {
                    EditButton()
                }
                
                if selectedProspects.isEmpty == false {
                    ToolbarItem(placement: .bottomBar) {
                        Button("delete Selected") {
                            delete()
                        }
                    }
                }
            }
            .sheet(isPresented: $isShowingScanner) {
                CodeScannerView(codeTypes: [.qr], simulatedData: "Parth Antala\nParth@icloud.com", completion: handleScan)
            }
            .sheet(isPresented: $showingDatePicker) {
                DatePickerView(date: $reminderDate) {
                    // Handle the reminder logic here
                    if let prospect = selectedProspect {
                        let calendar = Calendar.current
                        let hour = calendar.component(.hour, from: reminderDate)
                        let minute = calendar.component(.minute, from: reminderDate)
                        addNotification(for: prospect, at: hour, minute: minute)
                        showComfirmation = true
                        dismiss()
                    }
                        
                }
                .presentationDetents([.fraction(0.4), .medium, .large])
            }
            .alert("Reminder Set",isPresented: $showComfirmation) {
                Button("OK", role: .cancel) { }
            } message: {
                let calendar = Calendar.current
                let hour = calendar.component(.hour, from: reminderDate)
                let minute = calendar.component(.minute, from: reminderDate)
                
                if let prospect = selectedProspect {
                    let name = prospect.name
                    Text("Your reminder to contact \(name) has been set at \(hour):\(minute)")
                }
                
            }
            
        }
        
    }
    
    init(filter: FilterType) {
        self.filter = filter
        
        if filter != .none {
            let showContactedOnly = filter == .contacted
            
            _prospects = Query(filter: #Predicate {
                $0.isContacted == showContactedOnly
            }, sort: [SortDescriptor(\Prospect.name)])
        }
    }
    
    func handleScan(result: Result<ScanResult, ScanError>) {
        isShowingScanner = false
        switch result {
            
        case .success(let resulr):
            let details = resulr.string.components(separatedBy: "\n")
            guard details.count == 2 else { return }
            
            let person = Prospect(name: details[0], email: details[1], isContacted: false)
            modelContext.insert(person)
        case .failure(let error):
            print(error.localizedDescription)
        }
    }
    
    func delete() {
        for prospect in prospects {
            modelContext.delete(prospect)
        }
        
    }
    
    func addNotification(for prospect: Prospect, at hour: Int, minute: Int) {
        let center = UNUserNotificationCenter.current()
        
        let addRequest = {
            let content = UNMutableNotificationContent()
            content.title = "Contact \(prospect.name)"
            content.subtitle = prospect.email
            content.sound = UNNotificationSound.default
            
            var dateComponents = DateComponents()
            dateComponents.hour = hour
            dateComponents.minute = minute
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
            
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            center.add(request)
        }
        
        center.getNotificationSettings { settings in
            if settings.authorizationStatus == .authorized {
                addRequest()
            } else {
                center.requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                    if success {
                        addRequest()
                    } else if let error {
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
}


struct DatePickerView: View {
    @Binding var date: Date
    var onSave: () -> Void
    
    var body: some View {
        VStack {
            DatePicker("Select time", selection: $date, displayedComponents: .hourAndMinute)
                .datePickerStyle(WheelDatePickerStyle())
                .labelsHidden()
            
            Button("Save") {
                onSave()
            }
            .padding()
        }
        .padding()
    }
}


#Preview {
    ProspectsView(filter: .none)
        .modelContainer(for: Prospect.self)
}
