//
//  ContentView.swift
//  WearWeatherPred
//
//  Created by Наталья Захарова on 16.03.2025.
//
import SwiftUI

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = WardrobeViewModel() 

    var body: some View {
        OutfitView()
            .environmentObject(viewModel) //
    }
}


#Preview {
    ContentView()
}
