import SwiftUI

struct AgeInputView: View {
    @Binding var age: Int
    
    var body: some View {
        VStack(spacing: 24) {
            Text("How old are you?")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(Theme.textPrimary)
                .multilineTextAlignment(.center)
            
            Text("This helps us create your personalized plan")
                .font(.subheadline)
                .foregroundColor(Theme.textSecondary)
            
            Spacer()
                .frame(height: 20)
            
            StyledPickerView(
                selection: $age,
                range: 16...100
            )
            .frame(height: 150)
            
            Spacer()
        }
        .padding(.horizontal)
    }
}

#Preview {
    ZStack {
        Theme.background.ignoresSafeArea()
        AgeInputView(age: .constant(25))
    }
}