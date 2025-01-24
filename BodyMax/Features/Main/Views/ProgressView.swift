import SwiftUI

struct ProgressView: View {
    var body: some View {
        NavigationView {
            ZStack {
                Theme.background.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        // Weekly Progress Card
                        WeeklyProgressCard()
                        
                        // Progress Photos
                        ProgressPhotosCard()
                        
                        // Streak Calendar
                        StreakCard()
                    }
                    .padding()
                }
            }
            .navigationTitle("Progress")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct WeeklyProgressCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("This Week")
                .font(.headline)
                .foregroundColor(Theme.textPrimary)
            
            HStack(spacing: 20) {
                ProgressStat(title: "Workouts", value: "5/6")
                ProgressStat(title: "Calories", value: "2,450")
                ProgressStat(title: "Photos", value: "3/7")
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Theme.secondaryBackground)
        .cornerRadius(12)
    }
}

struct ProgressStat: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(value)
                .font(.title3)
                .bold()
                .foregroundColor(Theme.accent)
            Text(title)
                .font(.caption)
                .foregroundColor(Theme.textSecondary)
        }
    }
}

struct ProgressPhotosCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Progress Photos")
                .font(.headline)
                .foregroundColor(Theme.textPrimary)
            
            HStack {
                Text("Take your weekly progress photo")
                    .font(.subheadline)
                    .foregroundColor(Theme.textSecondary)
                
                Spacer()
                
                Image(systemName: "camera.fill")
                    .foregroundColor(Theme.accent)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Theme.secondaryBackground)
        .cornerRadius(12)
    }
}

struct StreakCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Current Streak")
                .font(.headline)
                .foregroundColor(Theme.textPrimary)
            
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("15 Days")
                        .font(.title2)
                        .bold()
                        .foregroundColor(Theme.accent)
                    Text("Keep it up!")
                        .font(.caption)
                        .foregroundColor(Theme.textSecondary)
                }
                
                Spacer()
                
                Image(systemName: "flame.fill")
                    .font(.title)
                    .foregroundColor(Theme.accent)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Theme.secondaryBackground)
        .cornerRadius(12)
    }
}

#Preview {
    ProgressView()
}