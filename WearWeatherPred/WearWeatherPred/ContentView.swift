//
//  ContentView.swift
//  WearWeatherPred
//
//  Created by Наталья Захарова on 16.03.2025.
//
import SwiftUI

struct ContentView: View {
    @State private var isShowingWardrobe = false

    var body: some View {
        OutfitView(isShowingWardrobe: $isShowingWardrobe)
            .environmentObject(WardrobeViewModel.shared)
            // ⬇️ добавляем sheet
            .sheet(isPresented: $isShowingWardrobe) {
                WardrobeView()                         // собственно список
                    .environmentObject(WardrobeViewModel.shared)
            }
    }
}

#Preview {
    ContentView()
}
