import SwiftUI

import SwiftUI

struct OutfitView: View {
    // временно оставляем ваши @State
    @State private var selectedCategory: OutfitType = .casual
    @State private var showSettings = false
    @Binding var isShowingWardrobe: Bool

    var body: some View {
        ZStack {
            Color.brandPrimary     
                .ignoresSafeArea()

            VStack(spacing: 0) {

        
                WeatherView(city: "Moscow")
                    .padding(.top, 10)

               
                VStack(spacing: 0) {

                    Picker("Type", selection: $selectedCategory) {
                        ForEach(OutfitType.allCases, id: \.self) { type in
                            Text(type.rawValue).tag(type)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.horizontal)
                    .padding(.top, 8)

       
                    ScrollView {
                        LazyVGrid(columns: [GridItem(.flexible()),
                                            GridItem(.flexible())],
                                  spacing: 16) {
                            ForEach(0..<6, id: \.self) { _ in
                                PlaceholderOutfitCard()
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 90)
                    }
                }
                .clipShape(RoundedRectangle(cornerRadius: 32, style: .continuous))
                .padding(.horizontal, 8)
                .padding(.bottom, 8)

                BottomBarView(isSettingsPresented: $showSettings,
                              isShowingWardrobe: $isShowingWardrobe)
                    .padding(.bottom, 4)
            }
        }
    }
}

