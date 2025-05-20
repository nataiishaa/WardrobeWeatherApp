import SwiftUI

struct ContentView: View {
    @State private var showWardrobe = false
    @State private var showSettingsFromWardrobe = false
    @State private var showOnboarding = !OnboardingState.shared.hasSeenOnboarding
    
    var body: some View {
        ZStack {
            OutfitView(isShowingWardrobe: $showWardrobe)
                .fullScreenCover(isPresented: $showWardrobe) {
                    WardrobeView(isShowingWardrobe: $showWardrobe,
                                 isSettingsPresented: $showSettingsFromWardrobe)
                }
            
            if showOnboarding {
                OnboardingView(isOnboardingShown: $showOnboarding)
                    .transition(.opacity)
                    .onDisappear {
                        OnboardingState.shared.markOnboardingAsSeen()
                    }
            }
        }
    }
}

#Preview {
    ContentView()
}
