import Foundation
import UIKit
import SwiftUI

class AnalysisService {
    static let shared = AnalysisService()
    private init() {}
    
    func performAnalysis(photos: [PhotoType: UIImage]) async throws -> Analysis {
        // Get user profile
        guard let userProfile = UserState.shared.userProfile else {
            throw NSError(domain: "AnalysisService", code: 1, userInfo: [
                NSLocalizedDescriptionKey: "User profile not found"
            ])
        }
        
        // Get dream physique
        guard let dreamPhysique = CoreDataManager.shared.fetchDreamPhysique() else {
            throw NSError(domain: "AnalysisService", code: 2, userInfo: [
                NSLocalizedDescriptionKey: "Dream physique not found"
            ])
        }
        
        do {
            // Get analysis from backend
            let analysis = try await APIClient.shared.analyze(
                photos: photos,
                dreamPhysique: dreamPhysique,
                userProfile: userProfile
            )
            
            // Save to CoreData
            CoreDataManager.shared.saveAnalysis(analysis)
            
            return analysis
        } catch {
            print("Analysis error:", error)
            throw error
        }
    }
}