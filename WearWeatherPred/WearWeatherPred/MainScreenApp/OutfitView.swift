import SwiftUI

struct OutfitView: View {
    @State private var selectedCategory: OutfitType = .casual
      @State private var showSettings = false
      @Binding var isShowingWardrobe: Bool

      var body: some View {
          ZStack {
              VStack {
                  WeatherView(city: "Moscow")
                      .padding(.top, 10)

                  Picker("Type", selection: $selectedCategory) {
                      ForEach(OutfitType.allCases, id: \.self) { type in
                          Text(type.rawValue).tag(type)
                      }
                  }
                  .pickerStyle(SegmentedPickerStyle())
                  .padding()

                  ScrollView {
                      LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                          ForEach(0..<6, id: \.self) { _ in
                              PlaceholderOutfitCard() 
                          }
                      }
                      .padding(.horizontal)
                  }

                  BottomBarView(isSettingsPresented: $showSettings, isShowingWardrobe: $isShowingWardrobe)
              }
          }
      }
}
