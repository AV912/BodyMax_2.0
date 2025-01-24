import SwiftUI

struct WeightInputView: View {
    @Binding var weight: Double  // Stored in kg
    let preference: MeasurementPreference
    
    var body: some View {
        VStack(spacing: 24) {
            Text("What's your weight?")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(Theme.textPrimary)
                .multilineTextAlignment(.center)
            
            Text("This helps us create your personalized plan")
                .font(.subheadline)
                .foregroundColor(Theme.textSecondary)
            
            Spacer()
                .frame(height: 20)
            
            VStack(spacing: 8) {
                StyledPickerView(
                    selection: Binding(
                        get: { 
                            if preference == .metric {
                                return Int(round(weight))
                            } else {
                                return Int(round(weight * 2.20462))
                            }
                        },
                        set: { 
                            if preference == .metric {
                                weight = Double($0)
                            } else {
                                weight = Double($0) / 2.20462
                            }
                        }
                    ),
                    range: preference == .metric ? 30...200 : 66...440
                )
                .frame(height: 150)
                
                Text(preference == .metric ? "kg" : "lbs")
                    .font(.headline)
                    .foregroundColor(Theme.textSecondary)
            }
            
            Spacer()
        }
        .padding(.horizontal)
    }
}

#Preview {
    ZStack {
        Theme.background.ignoresSafeArea()
        WeightInputView(weight: .constant(70), preference: .imperial)
    }
}