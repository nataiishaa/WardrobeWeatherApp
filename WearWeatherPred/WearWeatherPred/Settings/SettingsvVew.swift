//
//  Settingsview.swift
//  WearWeatherPred
//
//  Created by Наталья Захарова on 16.03.2025.
//

import SwiftUI

struct SettingsView: View {
    @Binding var isPresented: Bool
    @State private var isNotificationsEnabled = false

    var body: some View {
        VStack {
            HStack {
                Text("Settings")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                Spacer()
                Button(action: {
                    isPresented = false
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.white)
                        .font(.title)
                }
            }
            .padding()

            Divider().background(Color.white.opacity(0.3))

            // About section
            HStack {
                Image(systemName: "info.circle")
                    .foregroundColor(.white)
                Text("About")
                    .foregroundColor(.white)
                Spacer()
                Text(">")
                    .foregroundColor(.white.opacity(0.7))
            }
            .padding()

            // Push Notifications toggle
            HStack {
                Image(systemName: "bell.badge")
                    .foregroundColor(.white)
                Text("Push notifications")
                    .foregroundColor(.white)
                Spacer()
                Toggle("", isOn: $isNotificationsEnabled)
                    .labelsHidden()
                    .toggleStyle(SwitchToggleStyle(tint: Color.purple))
            }
            .padding()

            Spacer()
        }
        .frame(maxWidth: .infinity)
        .frame(height: UIScreen.main.bounds.height * 0.5) // Высота 50% экрана
        .background(Color.black.opacity(0.9))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .transition(.move(edge: .bottom))
    }
}
