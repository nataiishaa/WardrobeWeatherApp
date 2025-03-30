//
//  СlothingFormView.swift
//  WearWeatherPred
//
//  Created by Наталья Захарова on 16.03.2025.
//
import SwiftUI

import SwiftUI

struct ClothingFormView: View {
    @Binding var item: ClothingItem
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var viewModel: WardrobeViewModel
    @State private var showExitAlert = false

    var body: some View {
        ZStack(alignment: .topLeading) {
            // Полупрозрачный фон
            Color.black.opacity(0.2).ignoresSafeArea()

            VStack(spacing: 0) {
                // Фото и кнопка выхода
                ZStack(alignment: .topLeading) {
                    Image(uiImage: item.image)
                        .resizable()
                        .scaledToFill()
                        .frame(height: 300)
                        .clipped()

                    // Кнопка "назад"
                    Button(action: {
                        showExitAlert = true
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.white)
                            .padding(12)
                            .background(Color.black.opacity(0.6))
                            .clipShape(Circle())
                            .padding()
                    }
                }

                // Карточка
                VStack(spacing: 16) {
                    // Название
                    HStack {
                        Text("Name:").bold()
                        TextField("Enter name", text: $item.title)
                            .textFieldStyle(PlainTextFieldStyle())
                            .padding(8)
                            .background(Color.white)
                            .cornerRadius(6)
                            .overlay(RoundedRectangle(cornerRadius: 6).stroke(Color.gray.opacity(0.3)))
                    }

                    // Категория
                    VStack(alignment: .leading) {
                        Text("Category:").bold()
                        SelectionRow(
                            options: OutfitCategory.allCases.map { $0.rawValue },
                            selected: item.category?.rawValue ?? "",
                            onSelect: { selected in
                                item.category = OutfitCategory(rawValue: selected)
                            }
                        )
                    }

                    // Сезон
                    VStack(alignment: .leading) {
                        Text("Season").bold()
                        SelectionRow(
                            options: OutfitSeason.allCases.map { $0.rawValue },
                            selected: item.season?.rawValue ?? "",
                            onSelect: { selected in
                                item.season = OutfitSeason(rawValue: selected)
                            }
                        )
                    }

                    // Тип
                    VStack(alignment: .leading) {
                        Text("Type").bold()
                        SelectionRow(
                            options: OutfitType.allCases.map { $0.rawValue },
                            selected: item.type?.rawValue ?? "",
                            onSelect: { selected in
                                item.type = OutfitType(rawValue: selected)
                            }
                        )
                    }

                    // Кнопка "Add"
                    Button(action: {
                        viewModel.addItem(item)
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Add")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.black)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(24)
                .padding(.horizontal)
                .padding(.bottom)
                .shadow(color: .black.opacity(0.15), radius: 10, x: 0, y: -4)
            }
            .alert(isPresented: $showExitAlert) {
                Alert(
                    title: Text("Выйти без сохранения?"),
                    message: Text("Ваш элемент гардероба не будет сохранён."),
                    primaryButton: .destructive(Text("Выйти")) {
                        presentationMode.wrappedValue.dismiss()
                    },
                    secondaryButton: .cancel()
                )
            }
        }
    }
}
