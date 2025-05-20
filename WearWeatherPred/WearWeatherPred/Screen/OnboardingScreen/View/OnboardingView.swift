import SwiftUI

struct OnboardingView: View {
    @Binding var isOnboardingShown: Bool
    @State private var currentPage = 0
    @State private var showTutorial = false
    @State private var tutorialStep = 0
    @State private var showFinalScreen = false
    
    private let pages = [
        OnboardingPage(
            image: "tshirt.fill",
            title: "Welcome to WearWeather",
            description: "Your personal wardrobe assistant that helps you to choose outfits based on the weather"
        ),
        OnboardingPage(
            image: "cloud.sun.fill",
            title: "Weather-Based Outfits",
            description: "Get outfit recommendations tailored to current weather conditions in your city"
        ),
        OnboardingPage(
            image: "camera.fill",
            title: "Smart Wardrobe",
            description: "Add your clothes to the app and it will select the outfit for you itself"
        ),
        OnboardingPage(
            image: "wand.and.stars",
            title: "AI-Powered",
            description: "Our app analyzes your clothes and creates stylish combinations for any occasion"
        )
    ]
    
    private var tutorialSteps: [(message: String, position: CGPoint, showArrow: Bool, showTapIcon: Bool, highlightFrame: CGRect?)] {
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        let bottomInset = UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 0
        
        return [
            (message: "Real weather view", 
             position: CGPoint(x: screenWidth * 0.5, y: screenHeight * 0.15),
             showArrow: false,
             showTapIcon: true,
             highlightFrame: nil),
            
            (message: "Here will be the outfit for the day", 
             position: CGPoint(x: screenWidth * 0.5, y: screenHeight * 0.45),
             showArrow: false,
             showTapIcon: true,
             highlightFrame: nil),
            
            (message: "Use bottom toolbar to navigate and add items", 
             position: CGPoint(x: screenWidth * 0.5, y: screenHeight * 0.75),
             showArrow: true,
             showTapIcon: false,
             highlightFrame: CGRect(
                x: screenWidth * 0.5,
                y: screenHeight - 35 - bottomInset,
                width: screenWidth - 32,
                height: 70
             ))
        ]
    }
    
    var body: some View {
        ZStack {
            if showFinalScreen {
                FinalScreen(onDismiss: {
                    isOnboardingShown = false
                })
            } else if showTutorial {
                TutorialOverlay(
                    message: tutorialSteps[tutorialStep].message,
                    position: tutorialSteps[tutorialStep].position,
                    showArrow: tutorialSteps[tutorialStep].showArrow,
                    showTapIcon: tutorialSteps[tutorialStep].showTapIcon,
                    alignment: .center,
                    highlightFrame: tutorialSteps[tutorialStep].highlightFrame
                )
                .onTapGesture {
                    withAnimation {
                        tutorialStep += 1
                        if tutorialStep >= tutorialSteps.count {
                            showTutorial = false
                            showFinalScreen = true
                        }
                    }
                }
            } else {
                Color.brandPrimary.ignoresSafeArea()
                
                VStack(spacing: 20) {
                    HStack {
                        ForEach(0..<pages.count, id: \.self) { index in
                            Circle()
                                .fill(currentPage == index ? Color.white : Color.white.opacity(0.3))
                                .frame(width: 8, height: 8)
                        }
                    }
                    .padding(.top, 20)
                    
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
                                    showTutorial = true
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
}

#Preview {
    OnboardingView(isOnboardingShown: .constant(true))
} 
