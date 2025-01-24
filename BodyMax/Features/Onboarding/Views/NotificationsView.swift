import SwiftUI
import UserNotifications

struct NotificationsView: View {
    @Binding var notificationsEnabled: Bool
    @State private var isRequesting = false
    
    var body: some View {
        VStack(spacing: 24) {
            Text("Stay Updated")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(Theme.textPrimary)
                .multilineTextAlignment(.center)
            
            Text("Get reminders for workouts and updates on your progress")
                .font(.subheadline)
                .foregroundColor(Theme.textSecondary)
                .multilineTextAlignment(.center)
            
            Spacer()
                .frame(height: 20)
            
            Button {
                requestNotificationPermission()
            } label: {
                HStack {
                    Image(systemName: notificationsEnabled ? "bell.fill" : "bell")
                        .font(.title2)
                    
                    Text(notificationsEnabled ? "Notifications Enabled" : "Enable Notifications")
                        .font(.headline)
                }
                .foregroundColor(notificationsEnabled ? Theme.textPrimary : .white)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(notificationsEnabled ? Theme.secondaryBackground : Theme.accent)
                )
            }
            .disabled(isRequesting)
            
            if notificationsEnabled {
                Image(systemName: "checkmark.circle.fill")
                    .font(.title)
                    .foregroundColor(Theme.accent)
                    .padding(.top)
            }
            
            Spacer()
        }
        .padding(.horizontal)
    }
    
    private func requestNotificationPermission() {
        isRequesting = true
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
            DispatchQueue.main.async {
                notificationsEnabled = granted
                isRequesting = false
            }
        }
    }
}

#Preview {
    ZStack {
        Theme.background.ignoresSafeArea()
        NotificationsView(notificationsEnabled: .constant(false))
    }
}