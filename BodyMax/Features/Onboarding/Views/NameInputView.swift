import SwiftUI

struct NameInputView: View {
    @Binding var name: String
    
    var body: some View {
        VStack(spacing: 24) {
            Text("What's your name?")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(Theme.textPrimary)
                .multilineTextAlignment(.center)
            
            TextField("Enter your name", text: $name)
                .font(.system(size: 20))
                .foregroundColor(Theme.textPrimary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Spacer()
        }
        .padding(.top, 40)
    }
}

#Preview {
    ZStack {
        Theme.background.ignoresSafeArea()
        NameInputView(name: .constant(""))
    }
}