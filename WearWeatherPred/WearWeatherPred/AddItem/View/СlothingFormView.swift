//
//  СlothingFormView.swift
//  WearWeatherPred
//
//  Created by Наталья Захарова on 16.03.2025.
//
import SwiftUI

// MARK: — Form for Add & Edit
struct ClothingFormView: View {
    @Binding var item: ClothingItem
    @Binding var isPresented: Bool
    @EnvironmentObject var viewModel: WardrobeViewModel
    @State private var showExitAlert = false

    private var isEditingMode: Bool {
        viewModel.wardrobeItems.contains(where: { $0.id == item.id })
    }

    var body: some View {
        ZStack(alignment: .topLeading) {
            Color.black.opacity(0.2).ignoresSafeArea()

            VStack(spacing: 0) {
                ZStack(alignment: .topLeading) {
                    Image(uiImage: item.image)
                        .resizable().scaledToFill()
                        .frame(height: 300).clipped()
                    Button(action: { showExitAlert = true }) {
                        Image(systemName: "chevron.left")
                            .padding(12).background(Color.black.opacity(0.6)).clipShape(Circle())
                            .foregroundColor(.white).padding()
                    }
                }

                VStack(spacing: 16) {
                    HStack {
                        Text("Name:")
                            .montserrat(size: 16).bold()
                        TextField("Enter name", text: $item.title)
                        
                            .padding(8).background(Color.white).cornerRadius(6)
                            .overlay(RoundedRectangle(cornerRadius: 6)
                                .stroke(Color.gray.opacity(0.3)))
                    }
                    Group {
                        FieldPicker(label: "Category", options: OutfitCategory.allCases.map { $0.rawValue }, selection: $item.category)
                        FieldPicker(label: "Season", options: OutfitSeason.allCases.map { $0.rawValue }, selection: $item.season)
                        FieldPicker(label: "Type", options: OutfitType.allCases.map { $0.rawValue }, selection: $item.type)
                    }

                    Button(action: {
                        if isEditingMode {
                            viewModel.updateItem(item)
                        } else {
                            viewModel.addItem(item)
                        }
                        isPresented = false
                    }) {
                        Text(isEditingMode ? "Save" : "Add")
                            .montserrat(size: 16).bold()
                            .frame(maxWidth: .infinity).padding()
                            .background(Color.black).foregroundColor(.white)
                            .cornerRadius(12)
                    }

                    if isEditingMode {
                        Button(role: .destructive) {
                            viewModel.deleteItem(item)
                            isPresented = false
                        } label: {
                            Text("Delete")
                                .montserrat(size: 16).bold()
                                .frame(maxWidth: .infinity).padding()
                                .background(Color.red).foregroundColor(.white)
                                .cornerRadius(12)
                        }
                    }
                }
                .padding().background(Color(.systemGray6))
                .cornerRadius(24).padding(.horizontal).padding(.bottom)
                .shadow(color: .black.opacity(0.15), radius: 10)
            }
            .alert(isPresented: $showExitAlert) {
                Alert(title: Text("Exit without saving?"),
                      message: Text("Your changes won't be saved."),
                      primaryButton: .destructive(Text("Exit")) { isPresented = false },
                      secondaryButton: .cancel())
            }
        }
    }
}
