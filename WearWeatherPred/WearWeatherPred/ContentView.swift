//
//  ContentView.swift
//  WearWeatherPred
//
//  Created by Наталья Захарова on 16.03.2025.
//
import SwiftUI

struct ContentView: View {
    @State private var isShowingWardrobe = false
    @State private var showSettings = false

    var body: some View {
        OutfitView(isShowingWardrobe: $isShowingWardrobe)
            .environmentObject(WardrobeViewModel.shared)

            .fullScreenCover(isPresented: $isShowingWardrobe) {
                WardrobeView(isShowingWardrobe: $isShowingWardrobe,
                             isSettingsPresented: $showSettings)
                    .environmentObject(WardrobeViewModel.shared)
            }

    }
}

#Preview {
    ContentView()
}
