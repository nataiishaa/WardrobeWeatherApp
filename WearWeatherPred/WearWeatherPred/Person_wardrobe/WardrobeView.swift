//
//  WardrobeView.swift
//  WearWeatherPred
//
//  Created by Наталья Захарова on 16.03.2025.
//
import SwiftUI

struct WardrobeView: View {
    @State private var selectedCategory: OutfitCategory = .item
    @ObservedObject var viewModel = WardrobeViewModel.shared
    @State private var selectedItemIndex: Int?
    @State private var isEditing = false

    var filteredItems: [ClothingItem] {
        viewModel.wardrobeItems.filter { $0.category == selectedCategory }
    }

    var body: some View {
        VStack {
            Text("My Wardrobe")
                .font(.title)
                .padding()

            Picker("Category", selection: $selectedCategory) {
                ForEach(OutfitCategory.allCases, id: \.self) { category in
                    Text(category.rawValue).tag(category)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()

            ScrollView {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                    ForEach(filteredItems.indices, id: \.self) { index in
                        ClothingCardView(item: filteredItems[index])
                            .onTapGesture {
                                selectedItemIndex = index
                                isEditing = true
                            }
                    }
                }
                .padding()
            }
        }
        .sheet(isPresented: $isEditing) {
            if let index = selectedItemIndex {
                ClothingFormView(item: $viewModel.wardrobeItems[index])
            }
        }
    }
}
