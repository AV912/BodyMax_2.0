import SwiftUI

struct PhotoSelectionView: View {
    @ObservedObject var viewModel: PhotoCaptureViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                Theme.background.ignoresSafeArea()
                
                VStack(spacing: 24) {
                    Text("Progress Photos")
                        .font(.title2)
                        .bold()
                        .foregroundColor(Theme.textPrimary)
                    
                    Text("We need photos from all angles")
                        .font(.subheadline)
                        .foregroundColor(Theme.textSecondary)
                    
                    VStack(spacing: 16) {
                        ForEach(PhotoType.allCases, id: \.self) { photoType in
                            VStack(alignment: .leading, spacing: 12) {
                                HStack {
                                    Text(photoType.rawValue)
                                        .font(.headline)
                                        .foregroundColor(Theme.textPrimary)
                                    
                                    Spacer()
                                    
                                    if let image = viewModel.capturedPhotos[photoType] {
                                        Image(uiImage: image)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 50, height: 50)
                                            .clipShape(RoundedRectangle(cornerRadius: 8))
                                    }
                                }
                                
                                if viewModel.capturedPhotos[photoType] == nil {
                                    HStack(spacing: 16) {
                                        Button {
                                            viewModel.currentPhotoType = photoType
                                            viewModel.showingPhotoCapture = true
                                        } label: {
                                            HStack {
                                                Image(systemName: "camera.fill")
                                                Text("Take Photo")
                                            }
                                            .font(.subheadline)
                                            .foregroundColor(.white)
                                            .frame(maxWidth: .infinity)
                                            .frame(height: 44)
                                            .background(Theme.accent)
                                            .cornerRadius(22)
                                        }
                                        
                                        Button {
                                            viewModel.currentPhotoType = photoType
                                            viewModel.showingPhotoPicker = true
                                        } label: {
                                            HStack {
                                                Image(systemName: "photo.fill")
                                                Text("Upload")
                                            }
                                            .font(.subheadline)
                                            .foregroundColor(Theme.accent)
                                            .frame(maxWidth: .infinity)
                                            .frame(height: 44)
                                            .background(Theme.accent.opacity(0.2))
                                            .cornerRadius(22)
                                        }
                                    }
                                } else {
                                    HStack {
                                        Button {
                                            viewModel.currentPhotoType = photoType
                                            viewModel.showingPhotoCapture = true
                                        } label: {
                                            Text("Retake Photo")
                                                .font(.subheadline)
                                                .foregroundColor(Theme.accent)
                                        }
                                        
                                        Spacer()
                                        
                                        Button {
                                            viewModel.currentPhotoType = photoType
                                            viewModel.showingPhotoPicker = true
                                        } label: {
                                            Text("Choose Different")
                                                .font(.subheadline)
                                                .foregroundColor(Theme.accent)
                                        }
                                    }
                                }
                            }
                            .padding()
                            .background(Theme.secondaryBackground)
                            .cornerRadius(16)
                        }
                    }
                    .padding(.top)
                    
                    Button {
                        viewModel.startAnalysis()
                        dismiss()
                    } label: {
                        Text("Start Analysis")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(viewModel.allPhotosComplete ? Theme.accent : Theme.accent.opacity(0.5))
                            .cornerRadius(28)
                    }
                    .disabled(!viewModel.allPhotosComplete)
                    .padding(.top)
                }
                .padding()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .fullScreenCover(isPresented: $viewModel.showingPhotoCapture) {
                PhotoCaptureView(viewModel: viewModel)
            }
            .sheet(isPresented: $viewModel.showingPhotoPicker) {
                PhotoPickerView(viewModel: viewModel)
            }
        }
    }
}

#Preview {
    PhotoSelectionView(viewModel: PhotoCaptureViewModel(analysisViewModel: AnalysisViewModel()))
}