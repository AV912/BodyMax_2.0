import SwiftUI

enum Tab {
    case home
    case analysis
    case progress
    case profile
    
    var title: String {
        switch self {
        case .home: return "Home"
        case .analysis: return "Analysis"
        case .progress: return "Progress"
        case .profile: return "Profile"
        }
    }
    
    var icon: String {
        switch self {
        case .home: return "house.fill"
        case .analysis: return "chart.bar.fill"
        case .progress: return "chart.line.uptrend.xyaxis"
        case .profile: return "person.fill"
        }
    }
}

struct MainTabView: View {
    @State private var selectedTab: Tab = .home
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tag(Tab.home)
                .tabItem {
                    Label(Tab.home.title, systemImage: Tab.home.icon)
                }
            
            AnalysisView()
                .tag(Tab.analysis)
                .tabItem {
                    Label(Tab.analysis.title, systemImage: Tab.analysis.icon)
                }
            
            ProgressView()
                .tag(Tab.progress)
                .tabItem {
                    Label(Tab.progress.title, systemImage: Tab.progress.icon)
                }
            
            ProfileView()
                .tag(Tab.profile)
                .tabItem {
                    Label(Tab.profile.title, systemImage: Tab.profile.icon)
                }
        }
        .accentColor(Theme.accent)
        .onAppear {
            // Style tab bar
            let appearance = UITabBarAppearance()
            appearance.configureWithDefaultBackground()
            appearance.backgroundColor = UIColor(Theme.background)
            
            UITabBar.appearance().scrollEdgeAppearance = appearance
            UITabBar.appearance().standardAppearance = appearance
        }
    }
}

#Preview {
    MainTabView()
}