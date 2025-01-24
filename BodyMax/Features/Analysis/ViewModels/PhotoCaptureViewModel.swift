import SwiftUI

class PhotoCaptureViewModel: ObservableObject {
    @Published var currentPhotoType: PhotoType = .front
    @Published var capturedPhotos: [PhotoType: UIImage] = [:]
    @Published var showingPhotoCapture = false
    @Published var showingPhotoPicker = false
    @Published var showingReview = false
    @Published var showPhotoGuide = true
    
    var allPhotosComplete: Bool {
        PhotoType.allCases.allSatisfy { capturedPhotos[$0] != nil }
    }
    
    func savePhoto(_ image: UIImage, for type: PhotoType) {
        capturedPhotos[type] = image
    }
    
    func clearPhoto(for type: PhotoType) {
        capturedPhotos.removeValue(forKey: type)
    }
    
    func moveToNextPhoto() {
        let types = PhotoType.allCases
        if let currentIndex = types.firstIndex(of: currentPhotoType),
           currentIndex < types.count - 1 {
            currentPhotoType = types[currentIndex + 1]
            showPhotoGuide = true
        }
    }
    
    func moveToPreviousPhoto() {
        let types = PhotoType.allCases
        if let currentIndex = types.firstIndex(of: currentPhotoType),
           currentIndex > 0 {
            currentPhotoType = types[currentIndex - 1]
            showPhotoGuide = true
        }
    }
    
    func startAnalysis() {
        // TODO: Implement analysis
    }
    
    func clearAllPhotos() {
        capturedPhotos.removeAll()
    }
}