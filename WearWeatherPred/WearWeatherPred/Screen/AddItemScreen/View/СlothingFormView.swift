import SwiftUI

// MARK: — Form for Add & Edit
struct ClothingFormView: View {
    @Binding var item: ClothingItem
    @Binding var isPresented: Bool
    @EnvironmentObject var viewModel: WardrobeViewModel
    @State private var showExitAlert = false
    @State private var imageScale: CGFloat = 1.0

    private var isEditingMode: Bool {
        viewModel.wardrobeItems.contains(where: { $0.id == item.id })
    }

    var body: some View {
        ZStack(alignment: .topLeading) {
            Color.black.opacity(0.2).ignoresSafeArea()

            VStack(spacing: 0) {
                HStack {
                    Button(action: { showExitAlert = true }) {
                        Image(systemName: "chevron.left")
                            .padding(12)
                            .background(Color.black.opacity(0.6))
                            .clipShape(Circle())
                            .foregroundColor(.white)
                    }
                    Spacer()
                }
                .padding(.leading, 16)
                .padding(.top, 16)

                HStack {
                    Spacer()
                    Image(uiImage: item.image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 180, height: 200)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .shadow(radius: 6)
                    Spacer()
                }
                .padding(.vertical, 8)

                ScrollView {
                    VStack(spacing: 16) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Name")
                                .montserrat(size: 14).bold()
                                .foregroundColor(.gray)
                            TextField("Enter name", text: $item.title)
                                .padding(12)
                                .background(Color.white)
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.gray.opacity(0.3))
                                )
                        }
                        .padding(.horizontal)

                        HStack(spacing: 12) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Category")
                                    .montserrat(size: 14).bold()
                                    .foregroundColor(.gray)
                                Picker("", selection: $item.category) {
                                    Text("Select category").tag(Optional<OutfitCategory>.none)
                                    ForEach(OutfitCategory.allCases, id: \.self) { category in
                                        Text(category.rawValue).tag(Optional(category))
                                    }
                                }
                                .pickerStyle(MenuPickerStyle())
                                .padding(12)
                                .background(Color.white)
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.gray.opacity(0.3))
                                )
                            }
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Season")
                                    .montserrat(size: 14).bold()
                                    .foregroundColor(.gray)
                                Picker("", selection: $item.season) {
                                    Text("Select season").tag(Optional<OutfitSeason>.none)
                                    ForEach(OutfitSeason.allCases, id: \.self) { season in
                                        Text(season.rawValue).tag(Optional(season))
                                    }
                                }
                                .pickerStyle(MenuPickerStyle())
                                .padding(12)
                                .background(Color.white)
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.gray.opacity(0.3))
                                )
                            }
                        }
                        .padding(.horizontal)

                        HStack(spacing: 12) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Type")
                                    .montserrat(size: 14).bold()
                                    .foregroundColor(.gray)
                                Picker("", selection: $item.type) {
                                    Text("Select type").tag(Optional<OutfitType>.none)
                                    ForEach(OutfitType.allCases, id: \.self) { type in
                                        Text(type.rawValue).tag(Optional(type))
                                    }
                                }
                                .pickerStyle(MenuPickerStyle())
                                .padding(12)
                                .background(Color.white)
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.gray.opacity(0.3))
                                )
                            }
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Density")
                                    .montserrat(size: 14).bold()
                                    .foregroundColor(.gray)
                                Picker("", selection: $item.density) {
                                    Text("Select density").tag(Optional<OutfitDensity>.none)
                                    ForEach(OutfitDensity.allCases, id: \.self) { density in
                                        Text(density.rawValue).tag(Optional(density))
                                    }
                                }
                                .pickerStyle(MenuPickerStyle())
                                .padding(12)
                                .background(Color.white)
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.gray.opacity(0.3))
                                )
                            }
                        }
                        .padding(.horizontal)

                        // Weather protection
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Weather Protection")
                                .montserrat(size: 14).bold()
                                .foregroundColor(.gray)
                            Toggle("Waterproof", isOn: $item.isWaterproof)
                                .padding(12)
                                .background(Color.white)
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.gray.opacity(0.3))
                                )
                        }
                        .padding(.horizontal)

                        // Action buttons
                        VStack(spacing: 12) {
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
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.black)
                                    .foregroundColor(.white)
                                    .cornerRadius(12)
                            }

                            if isEditingMode {
                                Button(role: .destructive) {
                                    viewModel.deleteItem(item)
                                    isPresented = false
                                } label: {
                                    Text("Delete")
                                        .montserrat(size: 16).bold()
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(Color.red)
                                        .foregroundColor(.white)
                                        .cornerRadius(12)
                                }
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top, 8)
                    }
                    .padding(.vertical, 16)
                }
                .background(Color(.systemGray6))
            }
            .frame(maxWidth: 420)
            .padding(.horizontal, 24)
            .alert(isPresented: $showExitAlert) {
                Alert(title: Text("Exit without saving?"),
                      message: Text("Your changes won't be saved."),
                      primaryButton: .destructive(Text("Exit")) { isPresented = false },
                      secondaryButton: .cancel())
            }
        }
    }
}
