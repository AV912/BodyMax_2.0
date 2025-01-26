import SwiftUI

struct LoadingView: View {
    var body: some View {
        NavigationView {
            ZStack {
                Theme.background.ignoresSafeArea()
                
                VStack(spacing: 24) {
                    ProgressView()
                        .scaleEffect(1.5)
                        .tint(Theme.accent)
                    
                    Text("Analyzing Your Photos...")
                        .font(.headline)
                        .foregroundColor(Theme.textPrimary)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    LoadingView()
}