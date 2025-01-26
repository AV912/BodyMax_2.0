import Foundation
import SwiftUI

class OnboardingViewModel: ObservableObject {
    @Published var currentStep = 0
    @Published var userProfile: UserProfile
    
    init() {
        // Try to load existing profile, or create new one
        if let existingProfile = CoreDataManager.shared.fetchUserProfile() {
            self.userProfile = existingProfile
        } else {
            self.userProfile = UserProfile()
        }
    }
    
    enum OnboardingStep: Int, CaseIterable {
        case welcome
        case name
        case measurementPreference
        case age
        case weight
        case height
        case goal
        case notifications
        case rating
        
        var title: String {
            switch self {
            case .welcome: return "Welcome"
            case .name: return "What's your name?"
            case .measurementPreference: return "Choose Your Preference"
            case .age: return "How old are you?"
            case .weight: return "What's your weight?"
            case .height: return "What's your height?"
            case .goal: return "What's your goal?"
            case .notifications: return "Stay Updated"
            case .rating: return "Rate Your Experience"
            }
        }
        
        var subtitle: String? {
            switch self {
            case .age, .weight, .height:
                return "This helps us create your personalized plan"
            case .notifications:
                return "Get reminders and updates about your progress"
            default:
                return nil
            }
        }
    }
    
    var currentStepType: OnboardingStep {
        OnboardingStep(rawValue: currentStep) ?? .welcome
    }
    
    var canProceed: Bool {
        switch currentStepType {
        case .name:
            return !userProfile.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        case .goal:
            return true
        case .rating:
            return userProfile.hasCompletedRating
        default:
            return true
        }
    }
    
    func nextStep() {
        if currentStep < OnboardingStep.allCases.count - 1 {
            withAnimation {
                currentStep += 1
            }
        }
    }
    
    func previousStep() {
        if currentStep > 0 {
            withAnimation {
                currentStep -= 1
            }
        }
    }
    
    func completeOnboarding() {
        // Save profile to CoreData
        CoreDataManager.shared.saveUserProfile(userProfile)
        
        // Set onboarding as completed in UserDefaults
        UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
    }
}
