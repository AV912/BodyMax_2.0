import SwiftUI

struct PhotoCaptureView: View {
    @ObservedObject var viewModel: PhotoCaptureViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                Theme.background.ignoresSafeArea()
                
                // Camera here
                Color.black.ignoresSafeArea()
                
                VStack {
                    // Camera Indicator (placeholder)
                    Image(systemName: "camera.fill")
                        .font(.system(size: 48))
                        .foregroundColor(.white)
                    
                    Text("Camera Placeholder")
                        .font(.title)
                        .foregroundColor(.white)
                        .padding()
                    
                    Text("Taking: \(viewModel.currentPhotoType.rawValue)")
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    // Camera Controls
                    HStack(spacing: 60) {
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "xmark")
                                .font(.title)
                                .foregroundColor(.white)
                        }
                        
                        Button {
                            // Placeholder for taking photo
                            // Generate a placeholder image
                            let placeholderImage = UIImage() // Use actual placeholder later
                            viewModel.savePhoto(placeholderImage, for: viewModel.currentPhotoType)
                            viewModel.moveToNextPhoto()
                            if !viewModel.allPhotosComplete {
                                // Stay in camera for next photo
                                // Maybe show transition/animation
                            } else {
                                dismiss()
                            }
                        } label: {
                            Circle()
                                .strokeBorder(.white, lineWidth: 3)
                                .frame(width: 80, height: 80)
                                .overlay(
                                    Circle()
                                        .fill(.white)
                                        .frame(width: 70, height: 70)
                                )
                        }
                        
                        Button {
                            // Switch camera
                        } label: {
                            Image(systemName: "camera.rotate")
                                .font(.title)
                                .foregroundColor(.white)
                        }
                    }
                    .padding(.bottom, 50)
                }
            }
            .navigationBarHidden(true)
        }
    }
}

#Preview {
    PhotoCaptureView(viewModel: PhotoCaptureViewModel(analysisViewModel: AnalysisViewModel()))
}