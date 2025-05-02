//
//  Theame.swift
//  WearWeatherPred
//
//  Created by Наталья Захарова on 02.05.2025.
//


import SwiftUI

// MARK: - Brand palette
extension Color {
    static let brandPrimary = Color(red: 0x2D / 255.0,
                                    green: 0x31 / 255.0,
                                    blue: 0x42 / 255.0)

    static let brandSurface = Color(red: 0xF4 / 255.0,
                                    green: 0xF5 / 255.0,
                                    blue: 0xF7 / 255.0)

    static let brandAccent = Color.brandPrimary.opacity(0.9)
}

// MARK: - Helper modifiers
extension View {
  
    func brandHeader() -> some View {
        self.foregroundColor(.white)
            .padding(.vertical, 8)
            .padding(.horizontal)
            .background(Color.brandPrimary)
    }
}
