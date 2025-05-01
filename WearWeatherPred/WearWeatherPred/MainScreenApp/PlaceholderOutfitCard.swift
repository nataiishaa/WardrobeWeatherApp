//
//  PlaceholderOutfitCard.swift
//  WearWeatherPred
//
//  Created by Наталья Захарова on 30.03.2025.
//
import SwiftUI

struct PlaceholderOutfitCard: View {
    var body: some View {
        VStack {
            Rectangle()
                .fill(Color.gray.opacity(0.3))
                .frame(height: 100)
                .cornerRadius(8)

            Text("Autumn outfit")
                .font(.headline)

            Text("6 items")
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 2)
    }
}
