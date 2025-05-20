import SwiftUI

// MARK: — Main Wardrobe Screen
struct WardrobeView: View {
    @Binding var isShowingWardrobe: Bool
    @Binding var isSettingsPresented: Bool
    @ObservedObject private var viewModel = WardrobeViewModel.shared
    @State private var showSettings = false
    @State private var selectedCategory: OutfitCategory = .top

    @State private var selectedItemIndex: Int?
    @State private var isEditing = false

    @State private var showSourceDialog = false
    @State private var showImagePicker = false
    @State private var pickerSource: UIImagePickerController.SourceType = .photoLibrary
    @State private var pickedImage: UIImage?
    @State private var detectedTitle = ""
    @State private var showAddForm = false

    private var filteredItems: [ClothingItem] {
        viewModel.wardrobeItems.filter { $0.category == selectedCategory }
    }
// MARK: - body
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Color.brandPrimary
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                Text("My wardrobe")
                    .montserrat(size: 30).bold()
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 20)
                    .padding(.top, 44)
                
                
                VStack(spacing: 0) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(OutfitCategory.allCases, id: \.self) { category in
                                Button(action: {
                                    withAnimation(.easeInOut) {
                                        selectedCategory = category
                                    }
                                }) {
                                    VStack(spacing: 8) {
                                        Text(category.rawValue.capitalized)
                                            .montserrat(size: 14)
                                            .foregroundColor(selectedCategory == category ? .brandPrimary : .gray)
                                    }
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(selectedCategory == category ? Color.white : Color.gray.opacity(0.1))
                                            .shadow(color: selectedCategory == category ? Color.black.opacity(0.1) : .clear, radius: 4, x: 0, y: 2)
                                    )
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 12)
                    }
                    
                    Divider()
                        .padding(.horizontal)
                        .padding(.bottom, 8)
                    
                    ScrollView {
                        LazyVGrid(columns: Array(repeating: .init(.fixed(100)), count: 3),
                                  spacing: 12) {
                            if filteredItems.isEmpty {
                                Text("No items yet")
                                    .foregroundColor(.secondary)
                                    .padding(.top, 40)
                            } else {
                                ForEach(filteredItems, id: \.id) { item in
                                    ClothingCardView(item: item)
                                        .onTapGesture {
                                            if let idx = viewModel.wardrobeItems.firstIndex(where: { $0.id == item.id }) {
                                                selectedItemIndex = idx
                                                isEditing = true
                                            }
                                        }
                                }
                            }
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 16)
                    }
                }
                .background(Color.white)
                .cornerRadius(24, corners: [.topLeft, .topRight])
                .edgesIgnoringSafeArea(.bottom)

                BottomBarView(
                    activeTab: .wardrobe,
                    openWardrobe: { isShowingWardrobe = false },
                    openSettings: { isSettingsPresented.toggle() },
                    addItem: { showSourceDialog = true }
                )
                .padding(.vertical, 8)
                .background(Color.white)
            }
        }
        
        // MARK: - Add & edit dialogs (unchanged)
        
        .confirmationDialog("Add new item", isPresented: $showSourceDialog) {
            Button("Take photo") { pickerSource = .camera; showImagePicker = true }
            Button("Choose from gallery") { pickerSource = .photoLibrary; showImagePicker = true }
            Button("Cancel", role: .cancel) {}
        }
        .fullScreenCover(isPresented: $showImagePicker) {
            ImagePickerView(sourceType: pickerSource) { image in
                showImagePicker = false
                guard let image = image else { pickedImage = nil; return }
                pickedImage = image
                detectedTitle = "Detecting…"
                ImageClassifier.shared.classify(image: image) { result in
                    DispatchQueue.main.async {
                        detectedTitle = result ?? "Unknown"
                        showAddForm = true
                    }
                }
            }
        }
        .overlay(alignment: .center) {
            if showAddForm, let img = pickedImage {
                ZStack(alignment: .topLeading) {
                    Color.black.opacity(0.2)
                        .ignoresSafeArea()
                        .allowsHitTesting(false)
                    ClothingFormView(
                        item: .constant(ClothingItem(image: img,
                                                     title: detectedTitle,
                                                     category: .top,
                                                     season: .hot,
                                                     type: .daily)),
                        isPresented: $showAddForm
                    )
                    .environmentObject(viewModel)
                    .zIndex(1)
                }
            } else if isEditing, let idx = selectedItemIndex {
                ZStack(alignment: .topLeading) {
                    Color.black.opacity(0.2)
                        .ignoresSafeArea()
                        .allowsHitTesting(false)
                    ClothingFormView(
                        item: $viewModel.wardrobeItems[idx],
                        isPresented: $isEditing
                    )
                    .environmentObject(viewModel)
                    .zIndex(1)
                }
            }
        }
        .overlay {
            if isSettingsPresented {
                BottomBlurSheet(heightFactor: 0.5) {
                    SettingsView(isPresented: $isSettingsPresented)
                }
            }
        }
    }

    private var topInset: CGFloat {
        UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0
    }
    private var bottomInset: CGFloat {
        (UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 0) + 4
    }
}
