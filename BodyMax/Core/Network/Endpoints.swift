import Foundation
import UIKit
import SwiftUI

enum Endpoint {
    case analyze(photos: [PhotoType: UIImage], dreamPhysique: UIImage, userProfile: UserProfile)
    case transform(current: UIImage, dream: UIImage)
    
    var baseURL: String {
        return "https://bodymax-api.onrender.com"
    }
    
    var path: String {
        switch self {
        case .analyze:
            return "/analyze"
        case .transform:
            return "/transform"
        }
    }
    
    var url: URL {
        return URL(string: baseURL + path)!
    }
    
    var method: String {
        return "POST"
    }
}

// Request Models
struct AnalyzeRequest: Codable {
    let photos: [String: String]  // Photo type to base64
    let dreamPhysique: String    // base64
    let userProfile: UserProfileRequest
}

struct UserProfileRequest: Codable {
    let gender: String
    let age: Int
    let height: Double
    let weight: Double
    let fitnessGoal: String
    let measurementSystem: String
    let experienceLevel: String
    
    init(from profile: UserProfile) {
        self.gender = profile.measurementPreference.rawValue // Temporarily using this until we add gender
        self.age = profile.age
        self.height = profile.height
        self.weight = profile.weight
        self.fitnessGoal = profile.goal.rawValue
        self.measurementSystem = profile.measurementPreference.rawValue
        self.experienceLevel = "Beginner" // Can be enhanced later
    }
}