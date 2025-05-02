import SwiftUI

import SwiftUI

struct OutfitView: View {
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
        .overlay {
            if showSettings {
                Rectangle()
                    .fill(.ultraThinMaterial)
                    .opacity(0.8)
                    .ignoresSafeArea()
                    .onTapGesture { showSettings = false }
                
              
                GeometryReader { geo in
                    VStack(spacing: 0) {
                        Spacer()
                        SettingsView(isPresented: $showSettings)
                            .frame(maxWidth: .infinity)
                            .frame(height: geo.size.height * 0.5)
                            .background(Color.brandPrimary)
                            .clipShape(RoundedRectangle(cornerRadius: 32,
                                                        style: .continuous))
                            .transition(.move(edge: .bottom))
                            .animation(.easeOut(duration: 0.25), value: showSettings)
                    }
                    .ignoresSafeArea(edges: .bottom)
                }
            }
        }
    }
}
