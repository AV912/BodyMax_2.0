import SwiftUI

class AnalysisViewModel: ObservableObject {
    @Published var dreamPhysique: UIImage?
    @Published var bodyPhotos: [String: UIImage] = [:]
    @Published var showingPhotoPicker = false
    @Published var showingBodyPhotoCapture = false
    @Published var isLoading = false
    @Published var showingAnalysisResult = false
    @Published var analysisResult: String? = nil  // This will be replaced with proper analysis model later
    
    init() {
        // Load dream physique on init
        if let data = UserDefaults.standard.data(forKey: "dreamPhysiqueKey"),
           let image = UIImage(data: data) {
            self.dreamPhysique = image
        }
    }
    
    func saveDreamPhysique(_ image: UIImage) {
        if let data = image.jpegData(compressionQuality: 0.8) {
            UserDefaults.standard.set(data, forKey: "dreamPhysiqueKey")
            dreamPhysique = image
        }
    }
    
    func clearDreamPhysique() {
        UserDefaults.standard.removeObject(forKey: "dreamPhysiqueKey")
        dreamPhysique = nil
    }
    
    func startNewAnalysis() {
        showingBodyPhotoCapture = true
        // Clear any existing photos
        bodyPhotos.removeAll()
    }
    
    func performAnalysis(with photos: [PhotoType: UIImage]) {
        isLoading = true
        
        // TODO: Here we'll add the actual analysis API call
        // For now, just simulate a delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.isLoading = false
            // Set a placeholder result
            self.analysisResult = "Analysis completed! This is a placeholder result."
            self.showingAnalysisResult = true
            // Clear the photos after analysis
            self.bodyPhotos.removeAll()
        }
    }
    
    func cancelAnalysis() {
        bodyPhotos.removeAll()
        showingBodyPhotoCapture = false
    }
}