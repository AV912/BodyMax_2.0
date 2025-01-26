import SwiftUI
import CoreData

struct EditProfileView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var editedProfile: UserProfile
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    init(userProfile: UserProfile?) {
        _editedProfile = State(initialValue: userProfile ?? UserProfile())
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Theme.background.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Profile Fields
                        VStack(spacing: 16) {
                            ProfileField(title: "Name", text: $editedProfile.name)
                            
                            HStack {
                                Text("Age")
                                    .foregroundColor(Theme.textSecondary)
                                Spacer()
                                TextField("Age", value: $editedProfile.age, format: .number)
                                    .keyboardType(.numberPad)
                                    .multilineTextAlignment(.trailing)
                            }
                            .padding()
                            .background(Theme.secondaryBackground)
                            .cornerRadius(12)
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Goal")
                                    .foregroundColor(Theme.textSecondary)
                                
                                Picker("Goal", selection: $editedProfile.goal) {
                                    ForEach(FitnessGoal.allCases, id: \.self) { goal in
                                        Text(goal.rawValue)
                                            .tag(goal)
                                    }
                                }
                                .pickerStyle(.segmented)
                            }
                            .padding()
                            .background(Theme.secondaryBackground)
                            .cornerRadius(12)
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Measurement Preference")
                                    .foregroundColor(Theme.textSecondary)
                                
                                Picker("Measurement", selection: $editedProfile.measurementPreference) {
                                    ForEach(MeasurementPreference.allCases, id: \.self) { pref in
                                        Text(pref.rawValue.capitalized)
                                            .tag(pref)
                                    }
                                }
                                .pickerStyle(.segmented)
                            }
                            .padding()
                            .background(Theme.secondaryBackground)
                            .cornerRadius(12)
                            
                            if editedProfile.measurementPreference == .imperial {
                                HeightInputView(height: $editedProfile.height, preference: editedProfile.measurementPreference)
                            } else {
                                HStack {
                                    Text("Height (cm)")
                                        .foregroundColor(Theme.textSecondary)
                                    Spacer()
                                    TextField("Height", value: $editedProfile.height, format: .number)
                                        .keyboardType(.decimalPad)
                                        .multilineTextAlignment(.trailing)
                                }
                                .padding()
                                .background(Theme.secondaryBackground)
                                .cornerRadius(12)
                            }
                            
                            HStack {
                                Text("Weight (\(editedProfile.measurementPreference == .metric ? "kg" : "lbs"))")
                                    .foregroundColor(Theme.textSecondary)
                                Spacer()
                                TextField("Weight", value: $editedProfile.weight, format: .number)
                                    .keyboardType(.decimalPad)
                                    .multilineTextAlignment(.trailing)
                            }
                            .padding()
                            .background(Theme.secondaryBackground)
                            .cornerRadius(12)
                            
                            Toggle("Notifications", isOn: $editedProfile.notificationsEnabled)
                                .padding()
                                .background(Theme.secondaryBackground)
                                .cornerRadius(12)
                        }
                        .padding(.horizontal)
                    }
                }
            }
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveProfile()
                    }
                }
            }
            .alert("Profile Update", isPresented: $showingAlert) {
                Button("OK") {
                    if alertMessage.contains("successfully") {
                        dismiss()
                    }
                }
            } message: {
                Text(alertMessage)
            }
        }
    }
    
    private func saveProfile() {
        do {
            try CoreDataManager.shared.saveUserProfile(editedProfile)
            alertMessage = "Profile updated successfully!"
            showingAlert = true
        } catch {
            alertMessage = "Failed to update profile: \(error.localizedDescription)"
            showingAlert = true
        }
    }
}

struct ProfileField: View {
    let title: String
    @Binding var text: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .foregroundColor(Theme.textSecondary)
            
            TextField(title, text: $text)
                .textFieldStyle(.plain)
        }
        .padding()
        .background(Theme.secondaryBackground)
        .cornerRadius(12)
    }
}

#Preview {
    EditProfileView(userProfile: nil)
}
