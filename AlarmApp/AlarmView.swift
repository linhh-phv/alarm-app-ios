import SwiftUI

struct AlarmView: View {
    @State private var title: String = ""
    @State private var message: String = ""
    @State private var selectedDate = Date()
    @State private var showAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    
    let notificationCenter = UNUserNotificationCenter.current()
    
    init() {
        notificationCenter.requestAuthorization(options: [.alert, .sound]) { granted, error in
            if granted {
                print("Notification permission granted")
            } else {
                print("Notification permission denied")
            }
        }
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }
    
    func formattedDate(date: Date) -> String
    {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM y HH:mm"
        return formatter.string(from: date)
    }
    
    private func scheduleNotification() {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = message
        content.sound = .default
        
        // Chuyển đổi selectedDate thành thời gian thông báo
        let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: selectedDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
        
        // Tạo request thông báo
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        // Lên lịch thông báo
        notificationCenter.add(request) { error in
            if let error = error {
                alertTitle = "Error"
                alertMessage = "Error scheduling notification: \(error.localizedDescription)"
                showAlert = true
            } else {
                alertTitle = "Success"
                alertMessage = "Notification scheduled for \(formattedDate(date: selectedDate))"
                showAlert = true
            }
        }
    }
    
    var body: some View {
        VStack {
            Text("Alarm App")
            
            /** title */
            VStack {
                TextField("Title", text: $title)
                    .padding()
            }
            .background(Color(red: 0.945, green: 0.945, blue: 0.945))
            .cornerRadius(12)
            
            /** message */
            VStack {
                TextField("Message", text: $message)
                    .padding()
            }
            .background(Color(red: 0.945, green: 0.945, blue: 0.945))
            .cornerRadius(12)
            
            /** date picker */
            Text("Selected date: \(selectedDate, formatter: dateFormatter)")
                .padding()
            
            DatePicker("", selection: $selectedDate, displayedComponents: [.date, .hourAndMinute])
                .datePickerStyle(GraphicalDatePickerStyle())
                .padding()
            
            /** schedule */
            Button(action: {
                scheduleNotification()
            }, label: {
                Text("Schedule")
            })
        }
        .padding()
        .alert(isPresented: $showAlert) {
            Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
        .background(AlertView(title: alertTitle, message: alertMessage, isPresented: $showAlert))
    }
}

#Preview {
    AlarmView()
}
