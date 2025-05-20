import SwiftUI
import UserNotifications

struct SettingsView: View {
    @Binding var isPresented: Bool
    @State private var isNotificationsEnabled = false
    @State private var showAbout = false
    
    private enum Constants {
        static let titleFontSize: CGFloat = 16
        static let titleVerticalPadding: CGFloat = 12
        static let buttonVerticalPadding: CGFloat = 14
        static let horizontalPadding: CGFloat = 16
        static let dividerOpacity: Double = 0.2
        static let chevronOpacity: Double = 0.6
        static let toggleTintColor: Color = .purple
        static let closeButtonFontSize: Font = .title
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text("Settings")
                    .montserrat(size: Constants.titleFontSize).bold()
                    .foregroundColor(.white)
                
                Spacer()
                
                Button { isPresented = false } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(Constants.closeButtonFontSize)
                        .foregroundColor(.white)
                }
            }
            .padding(.horizontal, Constants.horizontalPadding)
            .padding(.vertical, Constants.titleVerticalPadding)
            
            Divider()
                .background(Color.white.opacity(Constants.dividerOpacity))
            
            Button {
                showAbout = true
            } label: {
                HStack {
                    Image(systemName: "info.circle")
                    Text("About")
                    Spacer()
                    Image(systemName: "chevron.right")
                        .opacity(Constants.chevronOpacity)
                }
                .foregroundColor(.white)
                .padding(.horizontal, Constants.horizontalPadding)
                .padding(.vertical, Constants.buttonVerticalPadding)
            }
            
            HStack {
                Image(systemName: "bell.badge")
                Text("Push notifications")
                Spacer()
                Toggle("", isOn: $isNotificationsEnabled)
                    .labelsHidden()
                    .toggleStyle(SwitchToggleStyle(tint: Constants.toggleTintColor))
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
            .padding(.horizontal, Constants.horizontalPadding)
            .padding(.vertical, Constants.buttonVerticalPadding)
            
            Spacer()
        }
        .ignoresSafeArea(.container, edges: .bottom)
        .sheet(isPresented: $showAbout) {
            AboutView()
        }
    }
}
