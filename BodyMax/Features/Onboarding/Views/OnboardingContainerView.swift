import SwiftUI

struct OnboardingContainerView: View {
    @StateObject private var viewModel = OnboardingViewModel()
    
    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()
            
            VStack {
                // Current view
                Group {
                    switch viewModel.currentStepType {
                    case .welcome:
                        WelcomeView()
                    case .name:
                        NameInputView(name: $viewModel.userProfile.name)
                    case .measurementPreference:
                        MeasurementPreferenceView(preference: $viewModel.userProfile.measurementPreference)
                    case .age:
                        AgeInputView(age: $viewModel.userProfile.age)
                    case .weight:
                        WeightInputView(
                            weight: $viewModel.userProfile.weight,
                            preference: viewModel.userProfile.measurementPreference
                        )
                    case .height:
                        HeightInputView(
                            height: $viewModel.userProfile.height,
                            preference: viewModel.userProfile.measurementPreference
                        )
                    case .goals:
                        GoalSelectionView(selectedGoal: $viewModel.userProfile.goal)
                    case .notifications:
                        NotificationsView(notificationsEnabled: $viewModel.userProfile.notificationsEnabled)
                    case .referral:
                        ReferralView(code: $viewModel.userProfile.referralCode)
                    case .rating:
                        RatingView(hasCompleted: $viewModel.userProfile.hasCompletedRating)
                    }
                }
                
                Spacer()
                
                // Navigation buttons
                VStack(spacing: 12) {
                    Button(action: {
                        if viewModel.currentStep == OnboardingViewModel.OnboardingStep.allCases.count - 1 {
                            viewModel.completeOnboarding()
                        } else {
                            viewModel.nextStep()
                        }
                    }) {
                        Text(viewModel.currentStep == OnboardingViewModel.OnboardingStep.allCases.count - 1 ? "Get Started" : "Next")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(viewModel.canProceed ? Theme.accent : Theme.accent.opacity(0.5))
                            .cornerRadius(28)
                    }
                    .disabled(!viewModel.canProceed)
                    
                    if viewModel.currentStep > 0 && viewModel.currentStep < OnboardingViewModel.OnboardingStep.allCases.count - 1 {
                        Button(action: {
                            viewModel.previousStep()
                        }) {
                            Text("Back")
                                .font(.headline)
                                .foregroundColor(Theme.accent)
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.bottom)
            }
        }
    }
}

#Preview {
    OnboardingContainerView()
}