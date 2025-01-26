import Foundation

enum MeasurementPreference: String, Codable, CaseIterable {
    case metric = "Metric"
    case imperial = "Imperial"
}

enum FitnessGoal: String, Codable, CaseIterable {
    case loseWeight = "Lose Weight"
    case gainMuscle = "Gain Muscle"
    case maintainWeight = "Maintain Physique"
}

struct UserProfile: Codable {
    var name: String = ""
    var measurementPreference: MeasurementPreference = .metric
    var age: Int = 25
    var weight: Double = 70
    var height: Double = 170
    var goal: FitnessGoal = .maintainWeight
    var notificationsEnabled: Bool = true
    var referralCode: String = ""
    var hasCompletedRating: Bool = false
}
