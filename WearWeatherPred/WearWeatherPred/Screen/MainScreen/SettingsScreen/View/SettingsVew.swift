import SwiftUI
import UserNotifications

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
