import SwiftUI

struct NumberPickerView: View {
    @Binding var selectedNumber: Int
    let range: ClosedRange<Int>
    let title: String
    let subtitle: String?
    
    var body: some View {
        VStack(spacing: 24) {
            Text(title)
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(Theme.textPrimary)
                .multilineTextAlignment(.center)
            
            if let subtitle = subtitle {
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundColor(Theme.textSecondary)
            }
            
            StyledPickerView(selection: $selectedNumber, range: range)
                .frame(height: 150)
        }
        .padding(.horizontal)
    }
}

#Preview {
    ZStack {
        Theme.background.ignoresSafeArea()
        NumberPickerView(
            selectedNumber: .constant(25),
            range: 18...100,
            title: "How old are you?",
            subtitle: "This helps us create your personalized plan"
        )
    }
}