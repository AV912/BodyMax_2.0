import SwiftUI

struct ProfileView: View {
    @AppStorage("userProfile") private var profileData: Data?
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = true
    @State private var showingEditProfile = false
    
    private var profile: UserProfile? {
        guard let data = profileData else { return nil }
        return try? JSONDecoder().decode(UserProfile.self, from: data)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Theme.background.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        // Profile Header
                        ProfileHeader(profile: profile)
                        
                        // Menu Items
                        VStack(spacing: 1) {
                            MenuButton(title: "Edit Profile", icon: "person.fill") {
                                showingEditProfile = true
                            }
                            
                            MenuButton(title: "Privacy Policy", icon: "lock.fill") {
                                // TODO: Show privacy policy
                            }
                            
                            MenuButton(title: "Settings", icon: "gear") {
                                // TODO: Show settings
                            }
                            
                            MenuButton(title: "Sign Out", icon: "arrow.right.square", textColor: .red) {
                                signOut()
                            }
                        }
                        .background(Theme.secondaryBackground)
                        .cornerRadius(12)
                    }
                    .padding()
                }
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private func signOut() {
        // Clear user data
        UserDefaults.standard.removeObject(forKey: "userProfile")
        hasCompletedOnboarding = false
    }
}

struct ProfileHeader: View {
    let profile: UserProfile?
    
    var body: some View {
        VStack(spacing: 16) {
            Circle()
                .fill(Theme.secondaryBackground)
                .frame(width: 100, height: 100)
                .overlay(
                    Image(systemName: "person.fill")
                        .font(.system(size: 40))
                        .foregroundColor(Theme.textSecondary)
                )
            
            if let profile = profile {
                Text(profile.name)
                    .font(.title2)
                    .bold()
                    .foregroundColor(Theme.textPrimary)
                
                Text("Member since Jan 2024")
                    .font(.subheadline)
                    .foregroundColor(Theme.textSecondary)
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Theme.secondaryBackground)
        .cornerRadius(12)
    }
}

struct MenuButton: View {
    let title: String
    let icon: String
    var textColor: Color = Theme.textPrimary
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .frame(width: 24)
                Text(title)
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.footnote)
                    .foregroundColor(Theme.textSecondary)
            }
            .foregroundColor(textColor)
            .padding()
            .background(Theme.secondaryBackground)
        }
    }
}

#Preview {
    ProfileView()
}