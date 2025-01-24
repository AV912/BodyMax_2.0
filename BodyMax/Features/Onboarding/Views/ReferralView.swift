import SwiftUI

struct ReferralView: View {
    @Binding var code: String
    
    var body: some View {
        VStack(spacing: 24) {
            Text("Got a Referral?")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(Theme.textPrimary)
                .multilineTextAlignment(.center)
            
            Text("Enter your referral code if you have one")
                .font(.subheadline)
                .foregroundColor(Theme.textSecondary)
                .multilineTextAlignment(.center)
            
            Spacer()
                .frame(height: 20)
            
            TextField("Enter referral code", text: $code)
                .textFieldStyle(CustomTextFieldStyle())
                .textInputAutocapitalization(.characters)
                .font(.system(size: 20))
                .multilineTextAlignment(.center)
                .onChange(of: code) { newValue in
                    code = newValue.uppercased()
                }
            
            if !code.isEmpty {
                Text("Code will be applied after subscription")
                    .font(.caption)
                    .foregroundColor(Theme.textSecondary)
            }
            
            Spacer()
        }
        .padding(.horizontal)
    }
}

struct CustomTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding()
            .background(Theme.secondaryBackground)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Theme.accent, lineWidth: 1)
            )
    }
}

#Preview {
    ZStack {
        Theme.background.ignoresSafeArea()
        ReferralView(code: .constant(""))
    }
}