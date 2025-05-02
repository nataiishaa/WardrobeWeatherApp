//
//  WardrobeView.swift
//  WearWeatherPred
//
//  Created by Наталья Захарова on 16.03.2025.
//
//import SwiftUI
//
//struct WardrobeView: View {
//    @State private var selectedCategory: OutfitCategory = .item
//    @ObservedObject var viewModel = WardrobeViewModel.shared
//    @State private var selectedItemIndex: Int?
//    @State private var isEditing = false
//
//    var filteredItems: [ClothingItem] {
//        viewModel.wardrobeItems.filter { $0.category == selectedCategory }
//    }
//
//    var body: some View {
//        VStack {
//            Text("My Wardrobe")
//                .font(.title2.weight(.semibold))
//            
//
//            Picker("Category", selection: $selectedCategory) {
//                ForEach(OutfitCategory.allCases, id: \.self) { category in
//                    Text(category.rawValue).tag(category)
//                }
//            }
//            .pickerStyle(SegmentedPickerStyle())
//            .padding()
//
//            ScrollView {
//                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
//                    ForEach(filteredItems.indices, id: \.self) { index in
//                        ClothingCardView(item: filteredItems[index])
//                            .onTapGesture {
//                                selectedItemIndex = index
//                                isEditing = true
//                            }
//                    }
//                }
//                .padding()
//            }
//        }
//  
//
//        .sheet(isPresented: $isEditing) {
//            if let index = selectedItemIndex {
//                ClothingFormView(item: $viewModel.wardrobeItems[index])
//            }
//        }
//    }
//}
//
//  WardrobeView.swift
//  Look&Weather
//

import SwiftUI

struct WardrobeView: View {

 
    @Binding var isShowingWardrobe: Bool
    @Binding var isSettingsPresented: Bool

    // ---------- внутренние стейты ----------
    @State private var selectedCategory: OutfitCategory = .item
    @ObservedObject private var viewModel = WardrobeViewModel.shared

    @State private var selectedItemIndex: Int?
    @State private var isEditing = false

    // ---------- вычисляемка ----------
    private var filteredItems: [ClothingItem] {
        viewModel.wardrobeItems.filter { $0.category == selectedCategory }
    }

    // ---------- UI ----------
    var body: some View {
        ZStack(alignment: .bottom) {

            // фон
            Color.brandPrimary.ignoresSafeArea()

            VStack(spacing: 0) {

                // ---------- верхний хедер ----------
                Text("My wardrobe")
                    .font(.title2.weight(.semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 20)
                    .padding(.top, topInset + 8)
                    .padding(.bottom, 16)

                // ---------- светлая карточка‑контейнер ----------
                VStack(spacing: 0) {

                    // Picker категорий
                    Picker("Category", selection: $selectedCategory) {
                        ForEach(OutfitCategory.allCases, id: \.self) { category in
                            Text(category.rawValue).tag(category)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.horizontal)
                    .padding(.top, 6)

                    // Сетка вещей
                    ScrollView {
                        LazyVGrid(columns: [.init(.flexible()),
                                            .init(.flexible()),
                                            .init(.flexible())],
                                  spacing: 16) {

                            if filteredItems.isEmpty {
                                Text("No items yet")
                                    .foregroundColor(.secondary)
                                    .padding(.top, 40)
                            } else {
                                ForEach(filteredItems.indices, id: \.self) { index in
                                    ClothingCardView(item: filteredItems[index])
                                        .onTapGesture {
                                            selectedItemIndex = index
                                            isEditing = true
                                        }
                                }
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 110)   // место под бар
                    }
                }
                .background(Color.brandSurface)
                .clipShape(RoundedRectangle(cornerRadius: 32, style: .continuous))
                .padding(.horizontal, 8)
                .padding(.bottom, 8)
            }

            // ---------- Bottom Bar ----------
            BottomBarView(isSettingsPresented: $isSettingsPresented,
                          isShowingWardrobe: $isShowingWardrobe)
                .padding(.horizontal, 16)
                .padding(.bottom, bottomInset)
        }
        // ---------- форма редактирования ----------
        .sheet(isPresented: $isEditing) {
            if let idx = selectedItemIndex {
                ClothingFormView(item: $viewModel.wardrobeItems[idx])
            }
        }
    }

    // ---------- helper‑insets ----------
    private var topInset: CGFloat {
        UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0
    }
    private var bottomInset: CGFloat {
        (UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 0) + 4
    }
}
