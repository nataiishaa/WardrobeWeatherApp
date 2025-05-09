import SwiftUI

struct OnboardingPage {
    let image: String
    let title: String
    let description: String
}

struct OnboardingView: View {
    @Binding var isOnboardingShown: Bool
    @State private var currentPage = 0
    
    private let pages = [
        OnboardingPage(
            image: "tshirt.fill",
            title: "Welcome to WearWeather",
            description: "Your personal AI-powered wardrobe assistant that helps you choose outfits based on the weather"
        ),
        OnboardingPage(
            image: "cloud.sun.fill",
            title: "Weather-Based Outfits",
            description: "Get outfit recommendations tailored to current weather conditions in your city"
        ),
        OnboardingPage(
            image: "camera.fill",
            title: "Smart Wardrobe",
            description: "Add your clothes to the app and let AI help you create perfect outfits"
        ),
        OnboardingPage(
            image: "wand.and.stars",
            title: "AI-Powered",
            description: "Our AI analyzes your clothes and creates stylish combinations for any occasion"
        )
    ]
    
    var body: some View {
        ZStack {
            Color.brandPrimary.ignoresSafeArea()
            
            VStack(spacing: 20) {
                // Page Control
                HStack {
                    ForEach(0..<pages.count, id: \.self) { index in
                        Circle()
                            .fill(currentPage == index ? Color.white : Color.white.opacity(0.3))
                            .frame(width: 8, height: 8)
                    }
                }
                .padding(.top, 20)
                
                // Content
                TabView(selection: $currentPage) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        VStack(spacing: 20) {
                            Image(systemName: pages[index].image)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 150, height: 150)
                                .foregroundColor(.white)
                            
                            Text(pages[index].title)
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            
                            Text(pages[index].description)
                                .font(.body)
                                .multilineTextAlignment(.center)
                                .foregroundColor(.white.opacity(0.8))
                                .padding(.horizontal, 32)
                        }
                        .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                
                // Navigation Buttons
                HStack {
                    if currentPage > 0 {
                        Button("Back") {
                            withAnimation {
                                currentPage -= 1
                            }
                        }
                        .foregroundColor(.white)
                    }
                    
                    Spacer()
                    
                    if currentPage < pages.count - 1 {
                        Button("Next") {
                            withAnimation {
                                currentPage += 1
                            }
                        }
                        .foregroundColor(.white)
                    } else {
                        Button("Get Started") {
                            withAnimation {
                                isOnboardingShown = false
                            }
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(Color.white.opacity(0.2))
                        .cornerRadius(20)
                    }
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 50)
            }
        }
    }
}

#Preview {
    OnboardingView(isOnboardingShown: .constant(true))
} 