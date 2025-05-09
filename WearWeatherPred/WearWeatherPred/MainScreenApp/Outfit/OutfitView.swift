import SwiftUI
import UIKit

struct OutfitView: View {
    @Binding var isShowingWardrobe: Bool
    @State private var showSettings = false

    @State private var selectedCategory: OutfitType = .casual
    @State private var showSourceDialog = false
    @State private var showImagePicker = false
    @State private var pickerSource: UIImagePickerController.SourceType = .photoLibrary

    @State private var newItem = ClothingItem(
        image: UIImage(),
        title: "",
        category: .item,
        season: .hot,
        type: .daily
    )
    @State private var detectedTitle = ""
    @State private var showClothingForm = false

    @State private var llmCollages: [OutfitCollage] = []
    @State private var isLoading = false
    @StateObject private var weatherService = WeatherService()

    private let wardrobeVM = WardrobeViewModel.shared

    var body: some View {
        ZStack {
            Color.brandPrimary
                .ignoresSafeArea()

            VStack(spacing: 0) {
                // 1) Weather header
                WeatherView(city: "Moscow")
                    .frame(maxWidth: .infinity)
                    .frame(height: 180)

                // 2) Content container
                VStack(spacing: 0) {
                    Picker("Type", selection: $selectedCategory) {
                        ForEach(OutfitType.allCases, id: \.self) { type in
                            Text(type.rawValue.capitalized).tag(type)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.horizontal)
                    .padding(.top, 16)

                    Divider()
                        .padding(.horizontal)
                        .padding(.bottom, 8)

                    ScrollView {
                        LazyVGrid(
                            columns: [
                                GridItem(.flexible()),
                                GridItem(.flexible())
                            ],
                            spacing: 16
                        ) {
                            if isLoading {
                                ProgressView()
                                    .padding(.top, 40)
                            } else {
                                ForEach(llmCollages, id: \.itemIDs) { col in
                                    Image(uiImage: col.image)
                                        .resizable().scaledToFit()
                                        .cornerRadius(12)
                                }
                            }
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 16)
                    }
                }
                .background(Color.white)
                .cornerRadius(24, corners: [.topLeft, .topRight])
                .edgesIgnoringSafeArea(.bottom)

                // 3) Bottom bar
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
        .confirmationDialog("Add new item", isPresented: $showSourceDialog) {
            Button("Take photo") {
                pickerSource = .camera
                showImagePicker = true
            }
            Button("Choose from gallery") {
                pickerSource = .photoLibrary
                showImagePicker = true
            }
            Button("Cancel", role: .cancel) {}
        }
        .fullScreenCover(isPresented: $showImagePicker) {
            ImagePickerView(sourceType: pickerSource) { image in
                showImagePicker = false
                guard let image = image else { return }

                detectedTitle = "Detecting…"
                newItem = ClothingItem(
                    image: image,
                    title: detectedTitle,
                    category: .item,
                    season: .hot,
                    type: .daily
                )

                ImageClassifier.shared.classify(image: image) { result in
                    DispatchQueue.main.async {
                        let title = result ?? "Unknown"
                        newItem.title = title
                        showClothingForm = true
                    }
                }
            }
        }
        .overlay {
            if showClothingForm {
                ZStack {
                    Color.black.opacity(0.2)
                        .ignoresSafeArea()

                    BottomBlurSheet(heightFactor: 0.9) {
                        ScrollView(.vertical, showsIndicators: false) {
                            ClothingFormView(
                                item: $newItem,
                                isPresented: $showClothingForm
                            )
                            .environmentObject(WardrobeViewModel.shared)
                            .padding(.horizontal)
                            .padding(.bottom, 20)
                        }
                    }
                }
                .transition(.move(edge: .bottom))
                .animation(.easeOut, value: showClothingForm)
            }
            else if showSettings {
                BottomBlurSheet {
                    SettingsView(isPresented: $showSettings)
                }
            }
        }
        .onAppear {
            weatherService.fetchWeather(city: "Moscow")
            Task { await regenerateIfPossible() }
        }
        .task(id: wardrobeVM.wardrobeItems.count) { await regenerateIfPossible() }
        .task(id: selectedCategory) { await regenerateIfPossible() }
    }
}

enum ClothingLayer { case top, bottom, outer, shoes, accessory, unknown }

extension ClothingItem {
    var layer: ClothingLayer {
        let key = title.lowercased()
        switch category {
        case .shoes:              return .shoes
        case .accessories:        return .accessory
        default:
            if key.contains("jacket") || key.contains("coat") || key.contains("hoodie") || key.contains("sweater") {
                return .outer
            }
            if key.contains("pants") || key.contains("trousers") || key.contains("jeans") || key.contains("skirt") {
                return .bottom
            }
            if key.contains("shirt") || key.contains("t-shirt") || key.contains("blouse") {
                return .top
            }
            return .unknown
        }
    }
}

extension OutfitView {

    @MainActor
    private func regenerateIfPossible() async {

        guard let w = weatherService.weather else { return }
        isLoading = true

        let t       = w.main.temp
        let isRain  = w.weather.first?.main == "Rain"

        let itemsByLayer = Dictionary(grouping: wardrobeVM.wardrobeItems, by: \.layer)

        func items(_ layer: ClothingLayer) -> [ClothingItem] {
            itemsByLayer[layer] ?? []
        }

        func okTemp(_ item: ClothingItem) -> Bool {
            switch t {
            case ...0:      return item.season == .cold
            case 0..<10:    return item.season == .cold || item.season == .rainy
            case 10..<18:   return item.season != .hot
            case 18..<26:   return item.season == .hot || item.season == .rainy || item.season == nil
            default:        return item.season == .hot
            }
        }

        let topsOK     = items(.top)     .filter(okTemp)
        let bottomsOK  = items(.bottom)  .filter(okTemp)
        let outerOK    = items(.outer)   .filter(okTemp)
        let shoesBase  = items(.shoes)   .filter(okTemp)
        let shoesOK    = isRain ? shoesBase.filter { $0.season == .rainy } : shoesBase
        let extrasOK   = items(.accessory)

        guard
            let top    = topsOK.randomElement(),
            let bottom = bottomsOK.randomElement(),
            let shoes  = shoesOK.randomElement() ?? shoesBase.randomElement()
        else {
            llmCollages = []
            isLoading = false
            return
        }

        // outer нужен, если холоднее 12 °С или дождь
        let needOuter = t < 12 || isRain
        let outerPick = needOuter ? outerOK.randomElement() : nil

        // до двух аксессуаров
        let chosenExtras = Array(extrasOK.shuffled().prefix(2))

        // итоговый список id
        var ids = [top.id, bottom.id, shoes.id]
        if let o = outerPick { ids.append(o.id) }
        ids.append(contentsOf: chosenExtras.map(\.id))

        // собираем коллаж
        let dict = Dictionary(uniqueKeysWithValues: wardrobeVM.wardrobeItems.map { ($0.id, $0) })
        llmCollages = [CollageBuilder.build(from: ids, wardrobe: dict)].compactMap { $0 }

        isLoading = false
    }
}

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
