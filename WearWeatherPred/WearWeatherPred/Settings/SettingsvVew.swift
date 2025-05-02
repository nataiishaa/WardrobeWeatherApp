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
        VStack(alignment: .leading, spacing: 0) {

            // ─── Header ─────────────────────────────
            HStack {
                Text("Settings")
                    .font(.title).bold()
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

            // ─── About row ──────────────────────────
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

            // ─── Notifications row ──────────────────
            HStack {
                Image(systemName: "bell.badge")
                Text("Push notifications")
                Spacer()
                Toggle("", isOn: $isNotificationsEnabled)
                    .labelsHidden()
                    .toggleStyle(SwitchToggleStyle(tint: .purple))
            }
            .foregroundColor(.white)
            .padding(.horizontal)
            .padding(.vertical, 14)

            Spacer()
        }
       
        .ignoresSafeArea(.container, edges: .bottom)
    }
}
