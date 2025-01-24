import SwiftUI

struct MeasurementPreferenceView: View {
    @Binding var preference: MeasurementPreference
    
    var body: some View {
        VStack(spacing: 24) {
            Text("Choose Your Preference")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(Theme.textPrimary)
                .multilineTextAlignment(.center)
            
            VStack(spacing: 16) {
                ForEach(MeasurementPreference.allCases, id: \.self) { pref in
                    Button {
                        preference = pref
                    } label: {
                        HStack {
                            Text(pref.rawValue)
                                .font(.headline)
                            Spacer()
                            if preference == pref {
                                Image(systemName: "checkmark.circle.fill")
                            }
                        }
                        .foregroundColor(Theme.textPrimary)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Theme.secondaryBackground)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(preference == pref ? Theme.accent : Color.clear, lineWidth: 2)
                                )
                        )
                    }
                }
            }
            .padding(.top)
            
            Spacer()
        }
        .padding(.top, 40)
        .padding(.horizontal)
    }
}

#Preview {
    ZStack {
        Theme.background.ignoresSafeArea()
        MeasurementPreferenceView(preference: .constant(.metric))
    }
}