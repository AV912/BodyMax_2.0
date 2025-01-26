import SwiftUI

struct ContentView: View {
    @State private var hasCompletedOnboarding: Bool
    
    init() {
        // Check if user profile exists in CoreData
        let profile = CoreDataManager.shared.fetchUserProfile()
        _hasCompletedOnboarding = State(initialValue: profile != nil)
    }
    
    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()
            
            if hasCompletedOnboarding {
                MainTabView()
            } else {
                OnboardingContainerView(hasCompletedOnboarding: $hasCompletedOnboarding)
            }
        }
    }
}

#Preview {
    ContentView()
}
