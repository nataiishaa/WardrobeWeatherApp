import SwiftUI
import UserNotifications

class NotificationManager {
    static let shared = NotificationManager()
    
    private init() {}
    
    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                print("Notification permission granted")
            } else if let error = error {
                print("Error requesting notification permission: \(error.localizedDescription)")
            }
        }
    }
    
    func scheduleWeatherNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Weather Update"
        content.body = "Check today's weather forecast and get outfit recommendations!"
        content.sound = .default
        
        // Schedule notification for 9 AM every day
        var dateComponents = DateComponents()
        dateComponents.hour = 9
        dateComponents.minute = 0
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: "weatherNotification", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
    
    func removeWeatherNotification() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["weatherNotification"])
    }
}

struct SettingsView: View {
    @Binding var isPresented: Bool
    @State private var isNotificationsEnabled = false
    @State private var showAbout = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text("Settings")
                    .montserrat(size: 16).bold()
                    .foregroundColor(.white)
                
                Spacer()
                
                Button { isPresented = false } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title)
                        .foregroundColor(.white)
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 12)
            
            Divider().background(Color.white.opacity(0.2))
            
            Button {
                showAbout = true
            } label: {
                HStack {
                    Image(systemName: "info.circle")
                    Text("About")
                    Spacer()
                    Image(systemName: "chevron.right")
                        .opacity(0.6)
                }
                .foregroundColor(.white)
                .padding(.horizontal)
                .padding(.vertical, 14)
            }
            
            HStack {
                Image(systemName: "bell.badge")
                Text("Push notifications")
                Spacer()
                Toggle("", isOn: $isNotificationsEnabled)
                    .labelsHidden()
                    .toggleStyle(SwitchToggleStyle(tint: .purple))
                    .onChange(of: isNotificationsEnabled) { newValue in
                        if newValue {
                            NotificationManager.shared.requestAuthorization()
                            NotificationManager.shared.scheduleWeatherNotification()
                        } else {
                            NotificationManager.shared.removeWeatherNotification()
                        }
                    }
            }
            .foregroundColor(.white)
            .padding(.horizontal)
            .padding(.vertical, 14)
            
            Spacer()
        }
        .ignoresSafeArea(.container, edges: .bottom)
        .sheet(isPresented: $showAbout) {
            AboutView()
        }
    }
}
