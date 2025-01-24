import SwiftUI

struct HomeView: View {
    @AppStorage("userProfile") private var profileData: Data?
    
    private var profile: UserProfile? {
        guard let data = profileData else { return nil }
        return try? JSONDecoder().decode(UserProfile.self, from: data)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Theme.background.ignoresSafeArea()
                
                VStack(alignment: .leading, spacing: 20) {
                    if let profile = profile {
                        Text("Welcome back, \(profile.name)!")
                            .font(.title2)
                            .bold()
                            .foregroundColor(Theme.textPrimary)
                    }
                    
                    // Today's Workout Section
                    WorkoutCard()
                    
                    // Nutrition Section
                    NutritionCard()
                    
                    Spacer()
                }
                .padding()
            }
            .navigationTitle("Home")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct WorkoutCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Today's Workout")
                .font(.headline)
                .foregroundColor(Theme.textPrimary)
            
            Text("Push Day")
                .font(.title3)
                .foregroundColor(Theme.accent)
            
            Text("4 exercises • 45 minutes")
                .font(.subheadline)
                .foregroundColor(Theme.textSecondary)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Theme.secondaryBackground)
        .cornerRadius(12)
    }
}

struct NutritionCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Nutrition")
                .font(.headline)
                .foregroundColor(Theme.textPrimary)
            
            HStack {
                VStack(alignment: .leading) {
                    Text("2,500")
                        .font(.title2)
                        .foregroundColor(Theme.accent)
                    Text("Daily Goal")
                        .font(.caption)
                        .foregroundColor(Theme.textSecondary)
                }
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text("1,850")
                        .font(.title2)
                        .foregroundColor(Theme.textPrimary)
                    Text("Consumed")
                        .font(.caption)
                        .foregroundColor(Theme.textSecondary)
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Theme.secondaryBackground)
        .cornerRadius(12)
    }
}

#Preview {
    HomeView()
}