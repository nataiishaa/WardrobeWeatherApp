import Foundation

class OnboardingState {
    static let shared = OnboardingState()
    
    private let hasSeenOnboardingKey = "hasSeenOnboardingt"
    
    private init() {}
    
    var hasSeenOnboarding: Bool {
        get {
            UserDefaults.standard.bool(forKey: hasSeenOnboardingKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: hasSeenOnboardingKey)
        }
    }
    
    func markOnboardingAsSeen() {
        hasSeenOnboarding = true
    }
    
    func resetOnboarding() {
        hasSeenOnboarding = false
    }
} 
