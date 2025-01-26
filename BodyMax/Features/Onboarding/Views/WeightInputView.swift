import SwiftUI

struct WeightInputView: View {
    @Binding var weight: Double  // Stored in kg
    let preference: MeasurementPreference
    @State private var displayWeight: Int
    
    init(weight: Binding<Double>, preference: MeasurementPreference) {
        self._weight = weight
        self.preference = preference
        let initialWeight = preference == .metric ?
            Int(round(weight.wrappedValue)) :
            Int(round(weight.wrappedValue * 2.20462))
        self._displayWeight = State(initialValue: initialWeight)
    }
    
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
            
            StyledPickerView(
                selection: $displayWeight,
                range: preference == .metric ? 30...200 : 66...440
            )
            .frame(height: 150)
            .onChange(of: displayWeight) { newValue in
                if preference == .metric {
                    weight = Double(newValue)
                } else {
                    weight = Double(newValue) / 2.20462
                }
            }
            
            Text(preference == .metric ? "kg" : "lbs")
                .font(.headline)
                .foregroundColor(Theme.textSecondary)
            
            Spacer()
        }
        .padding(.horizontal)
    }
}

#Preview {
    ZStack {
        Theme.background.ignoresSafeArea()
        WeightInputView(weight: .constant(70), preference: .metric)
    }
}