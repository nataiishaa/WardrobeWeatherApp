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
        category: .top,
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
        ZStack(alignment: .bottom) {
            Color.brandPrimary
                .ignoresSafeArea()
            
            VStack(spacing: 0) {

                WeatherView()
                    .frame(maxWidth: .infinity)
                    .frame(height: 180)

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
                        if isLoading {
                            ProgressView()
                                .padding(.top, 40)
                        } else if llmCollages.isEmpty {
                            VStack(spacing: 16) {
                                Image(systemName: "tshirt.fill")
                                    .font(.system(size: 50))
                                    .foregroundColor(.gray)
                                Text("No outfits yet")
                                    .font(.headline)
                                    .foregroundColor(.gray)

                                if let missingItems = getMissingItems() {
                                    VStack(alignment: .leading, spacing: 12) {
                                        Text("To create outfits, add these items:")
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                        
                                        ForEach(missingItems, id: \.self) { item in
                                            HStack {
                                                Image(systemName: "plus.circle.fill")
                                                    .foregroundColor(.brandPrimary)
                                                Text(item)
                                                    .font(.subheadline)
                                                    .foregroundColor(.gray)
                                            }
                                        }
                                    }
                                    .padding()
                                    .background(Color.white)
                                    .cornerRadius(12)
                                    .shadow(color: .black.opacity(0.05), radius: 5)
                                    .padding(.horizontal)
                                } else {
                                    Text("Add some clothes to your wardrobe to get outfit recommendations")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                        .multilineTextAlignment(.center)
                                        .padding(.horizontal)
                                }
                            }
                            .padding(.top, 60)
                        } else {
                            VStack(spacing: 16) {
                                ForEach(llmCollages, id: \.itemIDs) { collage in
                                    VStack(spacing: 12) {
                                        OutfitCardView(collage: collage)
                                            .frame(maxWidth: .infinity)
                                            .frame(height: 400)
                                        
                                        Button(action: {
                                            isLoading = true
                                            Task {
                                                await regenerateIfPossible()
                                            }
                                        }) {
                                            HStack {
                                                Image(systemName: "arrow.triangle.2.circlepath")
                                                Text("Generate new outfit")
                                            }
                                            .foregroundColor(.white)
                                            .padding(.horizontal, 20)
                                            .padding(.vertical, 12)
                                            .background(Color.brandPrimary)
                                            .cornerRadius(12)
                                        }
                                    }
                                }
                            }
                            .padding(.horizontal)
                            .padding(.vertical, 16)
                        }
                    }
                }
                .background(Color.white)
                .cornerRadius(24, corners: [.topLeft, .topRight])
                .edgesIgnoringSafeArea(.bottom)

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
                    category: .top,
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
        }
        .task(id: wardrobeVM.wardrobeItems.count) { await regenerateIfPossible() }
        .task(id: selectedCategory) { await regenerateIfPossible() }
    }
}

extension OutfitView {
    @MainActor
    private func regenerateIfPossible() async {
        guard let w = weatherService.weather else { return }
        isLoading = true

        do {
            let recommendedItems = try await GroqService.shared.generateOutfitRecommendation(
                weather: w,
                style: selectedCategory,
                availableItems: wardrobeVM.wardrobeItems
            )
            
            if let collage = CollageBuilder.build(
                from: recommendedItems.map { $0.id },
                wardrobe: Dictionary(uniqueKeysWithValues: wardrobeVM.wardrobeItems.map { ($0.id, $0) })
            ) {
                llmCollages = [collage]
                print("[Outfit] Successfully created collage using Groq recommendations")
            } else {
                print("[Outfit] Failed to create collage from Groq recommendations")
                fallbackToDefaultOutfit(w)
            }
        } catch {
            print("[Outfit] Groq generation failed: \(error)")
            fallbackToDefaultOutfit(w)
        }
        
        isLoading = false
    }
    
    private func fallbackToDefaultOutfit(_ weather: WeatherData) {
        let t = weather.main.temp
        let isRain = weather.weather.first?.main == "Rain"
        let isSnow = weather.weather.first?.main == "Snow"
        let windSpeed = weather.wind.speed

        print("[Outfit] Using fallback outfit generation")
        print("[Outfit] Weather conditions: temp=\(t), rain=\(isRain), snow=\(isSnow), wind=\(windSpeed)")

        let itemsByLayer = Dictionary(grouping: wardrobeVM.wardrobeItems, by: \.layer)
        
        func items(_ layer: Layer) -> [ClothingItem] {
            itemsByLayer[layer] ?? []
        }

        func okTemp(_ item: ClothingItem) -> Bool {
            let result = switch t {
            case ...0:      item.season == .cold
            case 0..<10:    item.season == .cold || item.season == .rainy
            case 10..<18:   item.season != .hot
            case 18..<26:   item.season == .hot || item.season == .rainy || item.season == nil
            default:        item.season == .hot
            }
            print("[Outfit] Temperature check for \(item.title): \(result) (temp: \(t), season: \(item.season?.rawValue ?? "nil"))")
            return result
        }

        // Type matching
        func okType(_ item: ClothingItem) -> Bool {
            guard let type = item.type else { return true }
            let result = type == selectedCategory
            print("[Outfit] Type check for \(item.title): \(result) (type: \(type.rawValue), selected: \(selectedCategory.rawValue))")
            return result
        }

        func okDensity(_ item: ClothingItem) -> Bool {
            guard let density = item.density else { 
                print("[Outfit] Density check for \(item.title): true (no density set)")
                return true 
            }
            
            let adjustedTemp = t - (windSpeed * 2)
            let result = switch adjustedTemp {
            case ...5:      density == .heavy
            case 5..<15:    density == .heavy || density == .medium
            case 15..<25:   density == .medium || density == .light
            default:        density == .light
            }
            print("[Outfit] Density check for \(item.title): \(result) (temp: \(adjustedTemp), density: \(density.rawValue))")
            return result
        }

        func okWeather(_ item: ClothingItem) -> Bool {
            if isRain || isSnow {
                let result = item.isWaterproof || item.season == .rainy
                print("[Outfit] Weather check for \(item.title): \(result) (waterproof: \(item.isWaterproof), season: \(item.season?.rawValue ?? "nil"))")
                return result
            }
            return true
        }

        let topsOK = items(.top)
            .filter(okTemp)
            .filter(okDensity)
            .filter(okWeather)
            .filter(okType)
        
        let bottomsOK = items(.bottom)
            .filter(okTemp)
            .filter(okDensity)
            .filter(okWeather)
            .filter(okType)
        
        let outerOK = items(.outer)
            .filter(okTemp)
            .filter(okDensity)
            .filter(okWeather)
            .filter(okType)
        
        let shoesOK = items(.shoes)
            .filter(okTemp)
            .filter(okWeather)
            .filter(okType)

        let accessoriesOK = items(.accessory)
            .filter(okType)

        print("[Outfit] Filtered items:")
        print("  Tops: \(topsOK.count)")
        print("  Bottoms: \(bottomsOK.count)")
        print("  Outer: \(outerOK.count)")
        print("  Shoes: \(shoesOK.count)")
        print("  Accessories: \(accessoriesOK.count)")

        var top: ClothingItem?
        var bottom: ClothingItem?
        var shoes: ClothingItem?
        var outer: ClothingItem?
        var accessory: ClothingItem?

        top = topsOK.randomElement()
        bottom = bottomsOK.randomElement()
        shoes = shoesOK.randomElement()
        accessory = accessoriesOK.randomElement()

        if top == nil {
            top = items(.top).randomElement()
            print("[Outfit] Using any available top: \(top?.title ?? "none")")
        }
        if bottom == nil {
            bottom = items(.bottom).randomElement()
            print("[Outfit] Using any available bottom: \(bottom?.title ?? "none")")
        }
        if shoes == nil {
            shoes = items(.shoes).randomElement()
            print("[Outfit] Using any available shoes: \(shoes?.title ?? "none")")
        }

        guard let top = top, let bottom = bottom, let shoes = shoes else {
            print("[Outfit] Failed to find basic items")
            llmCollages = []
            return
        }

        let needOuter = t < 12 || isRain || isSnow || windSpeed > 5
        if needOuter {
            outer = outerOK.randomElement() ?? items(.outer).randomElement()
            print("[Outfit] Selected outerwear: \(outer?.title ?? "none")")
        }

        var ids = [top.id, bottom.id, shoes.id]
        if let o = outer { ids.append(o.id) }
        if let a = accessory { ids.append(a.id) }

        print("[Outfit] Final outfit IDs: \(ids)")

        // MARK: -  Create collage
        
        if let collage = CollageBuilder.build(from: ids, wardrobe: Dictionary(uniqueKeysWithValues: wardrobeVM.wardrobeItems.map { ($0.id, $0) })) {
            llmCollages = [collage]
            print("[Outfit] Successfully created collage")
        } else {
            print("[Outfit] Failed to create collage")
        }
    }

    private func getMissingItems() -> [String]? {
        let itemsByLayer = Dictionary(grouping: wardrobeVM.wardrobeItems, by: \.layer)
        var missingItems: [String] = []
        
        // Check for essential items
        if itemsByLayer[.top]?.isEmpty ?? true {
            missingItems.append("Top (shirt, t-shirt, blouse)")
        }
        if itemsByLayer[.bottom]?.isEmpty ?? true {
            missingItems.append("Bottom (pants, jeans, skirt)")
        }
        if itemsByLayer[.shoes]?.isEmpty ?? true {
            missingItems.append("Shoes")
        }
        
        if let weather = weatherService.weather {
            let t = weather.main.temp
            let isRain = weather.weather.first?.main == "Rain"
            let isSnow = weather.weather.first?.main == "Snow"
            let windSpeed = weather.wind.speed
            
            if (t < 12 || isRain || isSnow || windSpeed > 5) && (itemsByLayer[.outer]?.isEmpty ?? true) {
                missingItems.append("Outerwear (jacket, coat)")
            }
            
            if (isRain || isSnow) && !(itemsByLayer[.shoes]?.contains { $0.isWaterproof } ?? false) {
                missingItems.append("Waterproof shoes")
            }
        }
        
        return missingItems.isEmpty ? nil : missingItems
    }
}
