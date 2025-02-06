import Foundation

class UserState: ObservableObject {
    static let shared = UserState()
    
    @Published var userProfile: UserProfile?
    
    private init() {
        // Load user profile from CoreData
        userProfile = CoreDataManager.shared.fetchUserProfile()
    }
}