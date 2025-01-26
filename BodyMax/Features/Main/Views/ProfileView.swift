import SwiftUI
import CoreData

struct ProfileView: View {
    @State private var userProfile: UserProfile?
    @State private var showingEditProfile = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Theme.background.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Header with greeting
                        if let profile = userProfile {
                            VStack(spacing: 16) {
                                Text("Hi \(profile.name)!")
                                    .font(.system(size: 28, weight: .bold))
                                    .foregroundColor(Theme.textPrimary)
                                
                                Text("Let's \(profile.goal.rawValue.lowercased())")
                                    .font(.headline)
                                    .foregroundColor(Theme.textSecondary)
                            }
                            .padding(.top, 20)
                        }
                        
                        // Stats Section
                        VStack(spacing: 16) {
                            HStack(spacing: 16) {
                                StatCard(title: "Weight", value: "\(Int(userProfile?.weight ?? 0)) \(userProfile?.measurementPreference == .metric ? "kg" : "lbs")")
                                StatCard(title: "Height", value: "\(Int(userProfile?.height ?? 0)) \(userProfile?.measurementPreference == .metric ? "cm" : "in")")
                            }
                            
                            HStack(spacing: 16) {
                                StatCard(title: "Age", value: "\(userProfile?.age ?? 0)")
                                StatCard(title: "Goal", value: userProfile?.goal.rawValue ?? "-")
                            }
                        }
                        .padding(.horizontal)
                        
                        // Settings Section
                        VStack(spacing: 8) {
                            Button(action: { showingEditProfile = true }) {
                                SettingsRow(icon: "person.fill", title: "Edit Profile")
                            }
                            
                            SettingsRow(icon: "bell.fill", title: "Notifications", showToggle: true, isOn: .constant(userProfile?.notificationsEnabled ?? false))
                            
                            SettingsRow(icon: "ruler", title: "Measurement", value: userProfile?.measurementPreference.rawValue.capitalized ?? "-")
                        }
                        .padding(.horizontal)
                        
                        Spacer()
                    }
                }
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showingEditProfile) {
                EditProfileView(userProfile: userProfile)
            }
        }
        .onAppear {
            userProfile = CoreDataManager.shared.fetchUserProfile()
        }
    }
}

struct StatCard: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.subheadline)
                .foregroundColor(Theme.textSecondary)
            
            Text(value)
                .font(.headline)
                .foregroundColor(Theme.textPrimary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Theme.secondaryBackground)
        .cornerRadius(12)
    }
}

struct SettingsRow: View {
    let icon: String
    let title: String
    var value: String? = nil
    var showToggle: Bool = false
    var isOn: Binding<Bool>? = nil
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(Theme.accent)
                .frame(width: 24, height: 24)
            
            Text(title)
                .foregroundColor(Theme.textPrimary)
            
            Spacer()
            
            if let value = value {
                Text(value)
                    .foregroundColor(Theme.textSecondary)
            }
            
            if showToggle, let isOn = isOn {
                Toggle("", isOn: isOn)
            }
            
            if !showToggle && value == nil {
                Image(systemName: "chevron.right")
                    .foregroundColor(Theme.textSecondary)
            }
        }
        .padding()
        .background(Theme.secondaryBackground)
        .cornerRadius(12)
    }
}

#Preview {
    ProfileView()
}