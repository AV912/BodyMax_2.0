import SwiftUI

struct GoalSelectionView: View {
    @Binding var selectedGoal: FitnessGoal
    
    var body: some View {
        VStack(spacing: 24) {
            Text("What's your goal?")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(Theme.textPrimary)
                .multilineTextAlignment(.center)
            
            Text("This helps us create your personalized plan")
                .font(.subheadline)
                .foregroundColor(Theme.textSecondary)
            
            Spacer()
                .frame(height: 20)
            
            VStack(spacing: 16) {
                ForEach(FitnessGoal.allCases, id: \.self) { goal in
                    GoalCard(
                        goal: goal,
                        isSelected: goal == selectedGoal,
                        action: {
                            withAnimation(.spring()) {
                                selectedGoal = goal
                            }
                        }
                    )
                }
            }
            
            Spacer()
        }
        .padding(.horizontal)
    }
}

struct GoalCard: View {
    let goal: FitnessGoal
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text(goal.rawValue)
                    .font(.headline)
                    .foregroundColor(Theme.textPrimary)
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(Theme.accent)
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Theme.secondaryBackground)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Theme.accent : Color.clear, lineWidth: 2)
            )
        }
    }
}

#Preview {
    ZStack {
        Theme.background.ignoresSafeArea()
        GoalSelectionView(selectedGoal: .constant(.loseWeight))
    }
}