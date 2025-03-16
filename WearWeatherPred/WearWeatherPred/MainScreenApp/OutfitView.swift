

import SwiftUI

import SwiftUI

struct OutfitView: View {
    @State private var selectedCategory: OutfitCategory = .accessories
    @State private var showSettings = false
    @State private var isShowingWardrobe = false 

    var body: some View {
        ZStack {
            VStack {
                WeatherView(city: "Moscow")
                    .padding(.top, 10)

                Picker("Category", selection: $selectedCategory) {
                    ForEach(OutfitCategory.allCases, id: \.self) { category in
                        Text(category.rawValue)
                            .tag(category)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()

                ScrollView {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                        ForEach(0..<6, id: \.self) { _ in
                            ClothingCardView(item: ClothingItem(image: UIImage(), title: "Placeholder", category: .accessories, season: "Hot", type: "Daily"))
                        }
                    }
                    .padding(.horizontal)
                }

                // ✅ Теперь передаём isShowingWardrobe в BottomBarView
                BottomBarView(isSettingsPresented: $showSettings, isShowingWardrobe: $isShowingWardrobe)
            }
            .blur(radius: showSettings ? 5 : 0)

            if showSettings {
                Color.black.opacity(0.4)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        showSettings = false
                    }

                SettingsView(isPresented: $showSettings)
                    .offset(y: showSettings ? 0 : UIScreen.main.bounds.height)
                    .animation(.spring())
            }
        }
        .animation(.easeInOut)
        .background(Color.gray.opacity(0.1))
    }
}

