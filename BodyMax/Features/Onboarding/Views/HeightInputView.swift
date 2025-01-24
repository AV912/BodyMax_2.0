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
                // Metric height picker
                VStack(spacing: 8) {
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
                }
            } else {
                // Imperial height picker (feet and inches)
                VStack(spacing: 24) {
                    VStack(spacing: 8) {
                        StyledPickerView(
                            selection: Binding(
                                get: { feet },
                                set: {
                                    feet = $0
                                    updateHeightFromImperial()
                                }
                            ),
                            range: 4...7
                        )
                        .frame(height: 150)
                        
                        Text("feet")
                            .font(.headline)
                            .foregroundColor(Theme.textSecondary)
                    }
                    
                    VStack(spacing: 8) {
                        StyledPickerView(
                            selection: Binding(
                                get: { inches },
                                set: {
                                    inches = $0
                                    updateHeightFromImperial()
                                }
                            ),
                            range: 0...11
                        )
                        .frame(height: 150)
                        
                        Text("inches")
                            .font(.headline)
                            .foregroundColor(Theme.textSecondary)
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