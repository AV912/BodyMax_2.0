import SwiftUI

struct ContentView: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    
    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()
            
            if !hasCompletedOnboarding {
                OnboardingContainerView()
            } else {
                MainTabView()
            }
        }
    }
}

#Preview {
    ContentView()
}