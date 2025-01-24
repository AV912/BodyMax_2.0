import SwiftUI

struct RequiredPhotosView: View {
    @ObservedObject var viewModel: PhotoCaptureViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                Theme.background.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        Text("Required Progress Photos")
                            .font(.title3)
                            .bold()
                            .foregroundColor(Theme.textPrimary)
                            .padding(.top)
                        
                        Text("We'll need photos from these angles")
                            .font(.subheadline)
                            .foregroundColor(Theme.textSecondary)
                        
                        // Photo requirements
                        VStack(spacing: 16) {
                            ForEach(PhotoType.allCases, id: \.self) { type in
                                PhotoRequirementCard(
                                    type: type,
                                    image: viewModel.capturedPhotos[type],
                                    onTakePhoto: {
                                        viewModel.currentPhotoType = type
                                        viewModel.showingPhotoCapture = true
                                    },
                                    onUploadPhoto: {
                                        viewModel.currentPhotoType = type
                                        viewModel.showingPhotoPicker = true
                                    }
                                )
                            }
                        }
                        .padding(.top)
                        
                        if viewModel.allPhotosComplete {
                            Button {
                                viewModel.showingReview = true
                            } label: {
                                Text("Review Photos")
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
            .sheet(isPresented: $viewModel.showingReview) {
                PhotoReviewView(viewModel: viewModel)
            }
        }
    }
}

#Preview {
    RequiredPhotosView(viewModel: PhotoCaptureViewModel())
}