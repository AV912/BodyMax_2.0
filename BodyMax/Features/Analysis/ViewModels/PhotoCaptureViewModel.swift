import SwiftUI

class PhotoCaptureViewModel: ObservableObject {
    @Published var currentPhotoType: PhotoType = .front
    @Published var capturedPhotos: [PhotoType: UIImage] = [:]
    @Published var showingPhotoCapture = false
    @Published var showingPhotoPicker = false
    @Published var showingAnalysisResult = false
    
    var analysisViewModel: AnalysisViewModel
    
    init(analysisViewModel: AnalysisViewModel) {
        self.analysisViewModel = analysisViewModel
    }
    
    var allPhotosComplete: Bool {
        PhotoType.allCases.allSatisfy { capturedPhotos[$0] != nil }
    }
    
    func savePhoto(_ image: UIImage, for type: PhotoType) {
        capturedPhotos[type] = image
        
        showingPhotoCapture = false
        showingPhotoPicker = false
    }
    
    func moveToNextPhoto() {
        let types = PhotoType.allCases
        guard let currentIndex = types.firstIndex(of: currentPhotoType) else { return }
        
        let nextIndex = currentIndex + 1
        if nextIndex < types.count {
            currentPhotoType = types[nextIndex]
        }
    }
    
    func startAnalysis() {
        print("Starting analysis with photos: \(capturedPhotos)")
        analysisViewModel.performAnalysis(with: capturedPhotos)
    }
    
    func clearAllPhotos() {
        capturedPhotos.removeAll()
        currentPhotoType = .front
    }
}