import SwiftUI

// MARK: — Main Outfit View
struct OutfitView: View {
    @Binding var isShowingWardrobe: Bool
    @State private var showSettings = false

    @State private var selectedCategory: OutfitType = .casual
    @State private var showSourceDialog = false
    @State private var showImagePicker = false
    @State private var pickerSource: UIImagePickerController.SourceType = .photoLibrary

    @State private var pickedImage: UIImage?
    @State private var detectedTitle = ""
    @State private var showClothingForm = false

    var body: some View {
        ZStack {
            // Фон всего экрана
            Color.brandPrimary
                .ignoresSafeArea()

            VStack(spacing: 0) {
                // 1) WeatherView: растянутый на всю ширину
                WeatherView(city: "Moscow")
                    .frame(maxWidth: .infinity)
                    .frame(height: 180)

                // 2) Белый контейнер с фильтром и контентом
                VStack(spacing: 0) {
                    // Сегментированный контрол
                    Picker("Type", selection: $selectedCategory) {
                        ForEach(OutfitType.allCases, id: \.self) { type in
                            Text(type.rawValue.capitalized)
                                .tag(type)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.horizontal)
                    .padding(.top, 16)

                    Divider()
                        .padding(.horizontal)
                        .padding(.bottom, 8)

                    // Сетка карточек
                    ScrollView {
                        LazyVGrid(columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ], spacing: 16) {
                            ForEach(0..<6, id: \.self) { _ in
                                PlaceholderOutfitCard()
                            }
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 16)
                    }
                }
                .background(Color.white)
                // Скругляем только верхние углы
                .cornerRadius(24, corners: [.topLeft, .topRight])
                .edgesIgnoringSafeArea(.bottom)

                // 3) Нижняя панель на белом фоне
                BottomBarView(
                    activeTab: .outfit,
                    openWardrobe:  { isShowingWardrobe = true },
                    openSettings: { showSettings.toggle() },
                    addItem:      { showSourceDialog = true }
                )
                .padding(.vertical, 8)
                .background(Color.white)
            }
        }
        // — здесь остаётся ваша логика выбора фото и overlay формы —
        .confirmationDialog("Add new item", isPresented: $showSourceDialog) {
            Button("Take photo") { pickerSource = .camera; showImagePicker = true }
            Button("Choose from gallery") { pickerSource = .photoLibrary; showImagePicker = true }
            Button("Cancel", role: .cancel) {}
        }
        .fullScreenCover(isPresented: $showImagePicker, onDismiss: {
            if pickedImage != nil { showClothingForm = true }
        }) {
            ImagePickerView(sourceType: pickerSource) { image in
                showImagePicker = false
                guard let image = image else { pickedImage = nil; return }
                pickedImage = image
                detectedTitle = "Detecting…"
                ImageClassifier.shared.classify(image: image) { result in
                    DispatchQueue.main.async { detectedTitle = result ?? "Unknown" }
                }
            }
        }
        .overlay(alignment: .center) {
            if showClothingForm, let img = pickedImage {
                ClothingFormView(
                    item: .constant(
                        ClothingItem(
                            image: img,
                            title: detectedTitle,
                            category: .item,
                            season: .hot,
                            type: .daily
                        )
                    ),
                    isPresented: $showClothingForm
                )
                .environmentObject(WardrobeViewModel.shared)
                .background(Color.black.opacity(0.2).ignoresSafeArea())
                .zIndex(1)
            }
        }
        .overlay(alignment: .bottom) {
            if showSettings {
                BottomBlurSheet {
                    SettingsView(isPresented: $showSettings)
                }
            }
        }
    }
}

// Утилита для скругления только отдельных углов
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}
