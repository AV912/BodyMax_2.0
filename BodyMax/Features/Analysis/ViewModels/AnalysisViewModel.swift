import SwiftUI

class AnalysisViewModel: ObservableObject {
    @Published var dreamPhysique: UIImage?
    @Published var showingPhotoPicker = false
    @Published var showingBodyPhotoCapture = false
    @Published var isLoading = false
    @Published var showingAnalysisResult = false
    @Published var showingLoadingView = false
    @Published var analyses: [Analysis] = []
    @Published var selectedAnalysis: Analysis?
    
    // Error handling
    @Published var showingError = false
    @Published var errorMessage = ""
    
    init() {
        self.dreamPhysique = CoreDataManager.shared.fetchDreamPhysique()
        loadAnalyses()
    }
    
    func saveDreamPhysique(_ image: UIImage) {
        CoreDataManager.shared.saveDreamPhysique(image)
        dreamPhysique = image
    }
    
    func clearDreamPhysique() {
        CoreDataManager.shared.clearDreamPhysique()
        dreamPhysique = nil
    }
    
    func loadAnalyses() {
        print("Loading analyses from CoreData...")
        analyses = CoreDataManager.shared.fetchAnalyses()
        print("Loaded \(analyses.count) analyses")
        selectedAnalysis = analyses.first
        if let first = analyses.first {
            print("Most recent analysis date: \(first.dateGenerated)")
        }
    }
    
    func startNewAnalysis() {
        showingBodyPhotoCapture = true
    }
    
    func performAnalysis(with photos: [PhotoType: UIImage]) {
        print("Starting analysis with photos: \(photos)")
        showingLoadingView = true
        errorMessage = ""
        showingError = false
        
        // Get current dream physique data
        let currentDreamPhysiqueData = dreamPhysique?.jpegData(compressionQuality: 0.8)
        
        Task {
            do {
                print("Getting analysis from API...")
                var analysis = try await APIClient.shared.analyze(
                    photos: photos,
                    dreamPhysique: dreamPhysique ?? UIImage(),
                    userProfile: UserState.shared.userProfile ?? UserProfile()
                )
                
                // Add dream physique data to analysis before saving
                analysis.dreamPhysiqueData = currentDreamPhysiqueData
                
                print("Saving analysis to CoreData...")
                CoreDataManager.shared.saveAnalysis(analysis)
                
                await MainActor.run {
                    print("Updating UI with new analysis...")
                    self.showingLoadingView = false
                    self.selectedAnalysis = analysis
                    self.loadAnalyses()
                    self.showingAnalysisResult = true
                    print("Analysis flow completed")
                }
            } catch {
                print("Error performing analysis:", error)
                await MainActor.run {
                    self.showingLoadingView = false
                    self.errorMessage = error.localizedDescription
                    self.showingError = true
                }
            }
        }
    }
}