import SwiftUI

struct WelcomeView: View {
    init() {}
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Text("Action is the")
                .font(.system(size: 36, weight: .bold))
                .foregroundColor(Theme.textPrimary)
            
            Text("key to all success")
                .font(.system(size: 36, weight: .bold))
                .foregroundColor(Theme.textPrimary)
            
            Spacer()
            
            // Progress dots at bottom
            HStack(spacing: 8) {
                ForEach(0..<3) { index in
                    Circle()
                        .fill(index == 0 ? Theme.accent : Color.gray.opacity(0.3))
                        .frame(width: 8, height: 8)
                }
            }
        }
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Theme.background.ignoresSafeArea()
            WelcomeView()
        }
    }
}