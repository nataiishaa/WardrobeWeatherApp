//
//  ContentView.swift
//  WearWeatherPred
//
//  Created by Наталья Захарова on 16.03.2025.
//
import SwiftUI

struct ContentView: View {
    @State private var showWardrobe = false
    @State private var showSettingsFromWardrobe = false
    
    var body: some View {
        OutfitView(isShowingWardrobe: $showWardrobe)
            .fullScreenCover(isPresented: $showWardrobe) {
                WardrobeView(isShowingWardrobe: $showWardrobe,
                             isSettingsPresented: $showSettingsFromWardrobe)
            }
    }
}

#Preview {
    ContentView()
}
