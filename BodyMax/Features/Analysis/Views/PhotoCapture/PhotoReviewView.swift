import SwiftUI

struct PhotoReviewView: View {
    @ObservedObject var viewModel: PhotoCaptureViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                Theme.background.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        Text("Review Your Photos")
                            .font(.title2)
                            .bold()
                            .foregroundColor(Theme.textPrimary)
                        
                        Text("Make sure each photo is clear and well-lit")
                            .font(.subheadline)
                            .foregroundColor(Theme.textSecondary)
                            .multilineTextAlignment(.center)
                        
                        ForEach(PhotoType.allCases, id: \.self) { type in
                            PhotoReviewCard(
                                type: type,
                                image: viewModel.capturedPhotos[type],
                                onRetake: {
                                    viewModel.currentPhotoType = type
                                    viewModel.showingPhotoCapture = true
                                }
                            )
                        }
                        
                        if viewModel.allPhotosComplete {
                            Button {
                                viewModel.startAnalysis()
                                dismiss()
                            } label: {
                                Text("Start Analysis")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 56)
                                    .background(Theme.accent)
                                    .cornerRadius(28)
                            }
                            .padding(.top)
                        }
                    }
                    .padding()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Back") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct PhotoReviewCard: View {
    let type: PhotoType
    let image: UIImage?
    let onRetake: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(type.rawValue)
                .font(.headline)
                .foregroundColor(Theme.textPrimary)
            
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 200)
                    .frame(maxWidth: .infinity)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                
                Button(action: onRetake) {
                    HStack {
                        Image(systemName: "camera")
                        Text("Retake Photo")
                    }
                    .font(.subheadline)
                    .foregroundColor(Theme.accent)
                }
            } else {
                VStack(spacing: 12) {
                    Image(systemName: "photo.fill")
                        .font(.system(size: 40))
                    Text("Photo not taken")
                        .font(.subheadline)
                }
                .foregroundColor(Theme.textSecondary)
                .frame(maxWidth: .infinity)
                .frame(height: 200)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Theme.textSecondary.opacity(0.5), style: StrokeStyle(lineWidth: 2, dash: [5]))
                )
            }
        }
        .padding()
        .background(Theme.secondaryBackground)
        .cornerRadius(12)
    }
}

#Preview {
    PhotoReviewView(viewModel: PhotoCaptureViewModel())
}