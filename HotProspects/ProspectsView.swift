//
//  ProspectsView.swift
//  HotProspects
//
//  Created by Brandon Knox on 6/7/21.
//

import SwiftUI
import CodeScanner
import UserNotifications

struct ProspectsView: View {
    enum FilterType {
        case none, contacted, uncontacted
    }
    
    @EnvironmentObject var prospects: Prospects
    @State private var isShowingScanner = false
    @State private var showingActionSheet = false
    @State private var sortName = true
    
    let filter: FilterType
    
    var title: String {
        switch filter {
        case .none:
            return "Everyone"
        case .contacted:
            return "Contacted people"
        case .uncontacted:
            return "Uncontacted people"
        }
    }
    
    var filteredProspects: [Prospect] {
        switch filter {
        case .none:
            if sortName {
                return prospects.people.sorted()
            } else {
                return prospects.people.sorted { (lhs: Prospect, rhs: Prospect) -> Bool in
                    return lhs.dateAdded > rhs.dateAdded
                }
            }
        case .contacted:
            if sortName {
                return prospects.people.sorted().filter { $0.isContacted }
            } else {
                return prospects.people.sorted { (lhs: Prospect, rhs: Prospect) -> Bool in
                    return lhs.dateAdded > rhs.dateAdded
                }.filter { $0.isContacted }
            }
        case .uncontacted:
            if sortName {
                return prospects.people.sorted().filter { !$0.isContacted }
            } else {
                return prospects.people.sorted { (lhs: Prospect, rhs: Prospect) -> Bool in
                    return lhs.dateAdded > rhs.dateAdded
                }.filter { !$0.isContacted }
            }
        }
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(filteredProspects) { prospect in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(prospect.name)
                                .font(.headline)
                            Text(prospect.emailAddress)
                                .foregroundColor(.secondary)
                        }
                        .contextMenu {
                            Button(prospect.isContacted ? "Mark Uncontacted" : "Mark Contacted") {
                                self.prospects.toggle(prospect)
                            }
                            if !prospect.isContacted {
                                Button("Remind Me") {
                                    self.addNotification(for: prospect)
                                }
                            }
                            Button("Sort options") {
                                self.showingActionSheet = true
                            }
                        }
                        Spacer()
                        if (prospect.isContacted && filter == .none) {
                            Image(systemName: "checkmark.circle")
                        } else if ((!prospect.isContacted) && filter == .none) {
                            Image(systemName: "questionmark.diamond")
                        }
                    }
                    .actionSheet(isPresented: $showingActionSheet) {
                        ActionSheet(title: Text("Sort options"), message: Text("Select sorting by name or most recently added"), buttons: [
                            .default(Text("Name")) {
                                sortName = true
                            },
                            .default(Text("Most recent")) {
                                sortName = false
                            },
                            .cancel()
                        ])
                    }
                }
            }
            
                .navigationBarTitle(title)
                .navigationBarItems(trailing: Button(action: {
                    self.isShowingScanner = true
                }) {
                    Image(systemName: "qrcode.viewfinder")
                    Text("Scan")
                })
            .sheet(isPresented: $isShowingScanner) {
                CodeScannerView(codeTypes: [.qr], simulatedData: "Paul Hudson\npaul@hackingwithswift.com", completion: self.handleScan)
            }
        }
    }
    
    func handleScan(result: Result<String, CodeScannerView.ScanError>) {
        self.isShowingScanner = false
        switch result {
        case .success(let code):
            let details = code.components(separatedBy: "\n")
            guard details.count == 2 else { return }
            
            let person = Prospect()
            person.name = details[0]
            person.emailAddress = details[1]
            self.prospects.add(person)
        case .failure(let error):
            print("Scanning failed")
        }
    }
    
    func addNotification(for prospect: Prospect) {
        let center = UNUserNotificationCenter.current()

        let addRequest = {
            let content = UNMutableNotificationContent()
            content.title = "Contact \(prospect.name)"
            content.subtitle = prospect.emailAddress
            content.sound = UNNotificationSound.default

            var dateComponents = DateComponents()
            dateComponents.hour = 9
//            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
            // test code - comment out when done and enable above to get 9 a.m. alerts
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)

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
                    } else {
                        print("D'oh")
                    }
                }
            }
        }
    }
}

struct ProspectsView_Previews: PreviewProvider {
    static var previews: some View {
        ProspectsView(filter: .none)
    }
}
