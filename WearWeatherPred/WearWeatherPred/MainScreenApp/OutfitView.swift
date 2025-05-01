import SwiftUI

struct OutfitView: View {
    @State private var selectedCategory: OutfitCategory = .accessories
      @State private var showSettings = false
      @Binding var isShowingWardrobe: Bool

      var body: some View {
          ZStack {
              VStack {
                  WeatherView(city: "Moscow")
                      .padding(.top, 10)

                  Picker("Category", selection: $selectedCategory) {
                      ForEach(OutfitCategory.allCases, id: \.self) { category in
                          Text(category.rawValue).tag(category)
                      }
                  }
                  .pickerStyle(SegmentedPickerStyle())
                  .padding()

                  ScrollView {
                      LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                          ForEach(0..<6, id: \.self) { _ in
                              PlaceholderOutfitCard() // просто заглушка
                          }
                      }
                      .padding(.horizontal)
                  }

                  BottomBarView(isSettingsPresented: $showSettings, isShowingWardrobe: $isShowingWardrobe)
              }
          }
      }
}
