import SwiftUI

struct OnboardingContainerView: View {
    @StateObject private var viewModel = OnboardingViewModel()
    @Binding var hasCompletedOnboarding: Bool
    
    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()
            
            VStack {
                TabView(selection: $viewModel.currentStep) {
                    WelcomeView()
                        .tag(0)
                    
                    NameInputView(name: $viewModel.userProfile.name)
                        .tag(1)
                    
                    MeasurementPreferenceView(preference: $viewModel.userProfile.measurementPreference)
                        .tag(2)
                    
                    AgeInputView(age: $viewModel.userProfile.age)
                        .tag(3)
                    
                    WeightInputView(
                        weight: $viewModel.userProfile.weight,
                        preference: viewModel.userProfile.measurementPreference
                    )
                    .tag(4)
                    
                    HeightInputView(
                        height: $viewModel.userProfile.height,
                        preference: viewModel.userProfile.measurementPreference
                    )
                    .tag(5)
                    
                    GoalSelectionView(selectedGoal: $viewModel.userProfile.goal)
                        .tag(6)
                    
                    NotificationsView(notificationsEnabled: $viewModel.userProfile.notificationsEnabled)
                        .tag(7)
                    
                    RatingView(hasCompleted: $viewModel.userProfile.hasCompletedRating)
                        .tag(8)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .animation(.easeInOut, value: viewModel.currentStep)
                .scrollDisabled(true)  // Disable TabView scrolling
                
                Spacer()
                
                VStack(spacing: 12) {
                    Button(action: {
                        if viewModel.currentStep == OnboardingViewModel.OnboardingStep.allCases.count - 1 {
                            viewModel.completeOnboarding()
                            hasCompletedOnboarding = true
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
                    
                    if viewModel.currentStep > 0 {
                        Button(action: viewModel.previousStep) {
                            Text("Back")
                                .font(.headline)
                                .foregroundColor(Theme.textSecondary)
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 34)
            }
        }
    }
}

#Preview {
    ContentView()
}
