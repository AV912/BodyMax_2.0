import Foundation

extension UserDefaults {
    private enum Keys {
        static let userProfile = "userProfile"
        static let hasCompletedOnboarding = "hasCompletedOnboarding"
    }
    
    var userProfile: UserProfile? {
        get {
            guard let data = object(forKey: Keys.userProfile) as? Data else { return nil }
            return try? JSONDecoder().decode(UserProfile.self, from: data)
        }
        set {
            guard let data = try? JSONEncoder().encode(newValue) else { return }
            set(data, forKey: Keys.userProfile)
        }
    }
    
    var hasCompletedOnboarding: Bool {
        get { bool(forKey: Keys.hasCompletedOnboarding) }
        set { set(newValue, forKey: Keys.hasCompletedOnboarding) }
    }
}