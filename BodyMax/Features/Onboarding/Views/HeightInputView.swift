import SwiftUI

struct HeightInputView: View {
    @Binding var height: Double  // Stored in cm
    let preference: MeasurementPreference
    
    // For imperial measurements
    @State private var feet: Int = 5
    @State private var inches: Int = 8
    
    var body: some View {
        VStack(spacing: 24) {
            Text("What's your height?")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(Theme.textPrimary)
                .multilineTextAlignment(.center)
            
            Text("This helps us create your personalized plan")
                .font(.subheadline)
                .foregroundColor(Theme.textSecondary)
            
            Spacer()
                .frame(height: 20)
            
            if preference == .metric {
                StyledPickerView(
                    selection: Binding(
                        get: { Int(round(height)) },
                        set: { height = Double($0) }
                    ),
                    range: 120...220
                )
                .frame(height: 150)
                
                Text("cm")
                    .font(.headline)
                    .foregroundColor(Theme.textSecondary)
            } else {
                VStack(spacing: 20) {  
                    // Feet Picker
                    VStack {
                        Text("Feet")
                            .font(.headline)
                            .foregroundColor(Theme.textSecondary)
                        
                        StyledPickerView(
                            selection: $feet,
                            range: 4...7
                        )
                        .frame(height: 150)
                    }
                    
                    // Inches Picker
                    VStack {
                        Text("Inches")
                            .font(.headline)
                            .foregroundColor(Theme.textSecondary)
                        
                        StyledPickerView(
                            selection: $inches,
                            range: 0...11
                        )
                        .frame(height: 150)
                    }
                }
            }
            
            Spacer()
        }
        .padding(.horizontal)
        .onAppear {
            if preference == .imperial {
                let totalInches = height / 2.54
                feet = Int(totalInches) / 12
                inches = Int(totalInches) % 12
            }
        }
        .onChange(of: feet) { _ in updateHeightFromImperial() }
        .onChange(of: inches) { _ in updateHeightFromImperial() }
    }
    
    private func updateHeightFromImperial() {
        let totalInches = (feet * 12) + inches
        height = Double(totalInches) * 2.54
    }
}

#Preview {
    ZStack {
        Theme.background.ignoresSafeArea()
        HeightInputView(height: .constant(170), preference: .imperial)
    }
}