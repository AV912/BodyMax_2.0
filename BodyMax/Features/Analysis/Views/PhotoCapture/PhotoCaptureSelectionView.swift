import SwiftUI
import PhotosUI

struct PhotoCaptureSelectionView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: PhotoCaptureViewModel
    
    var body: some View {
        NavigationView {
            ZStack {
                Theme.background.ignoresSafeArea()
                
                VStack(spacing: 24) {
                    Text("Take Progress Photos")
                        .font(.title2)
                        .bold()
                        .foregroundColor(Theme.textPrimary)
                        .padding(.top)
                    
                    Text("We'll need photos from different angles to track your progress")
                        .font(.subheadline)
                        .foregroundColor(Theme.textSecondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    VStack(spacing: 16) {
                        // Take photos with camera option
                        Button {
                            viewModel.showingPhotoCapture = true
                        } label: {
                            SelectionCard(
                                icon: "camera.fill",
                                title: "Take Photos Now",
                                subtitle: "Use your camera to take new photos"
                            )
                        }
                        
                        // Upload existing photos option
                        Button {
                            viewModel.showingPhotoPicker = true
                        } label: {
                            SelectionCard(
                                icon: "photo.fill",
                                title: "Upload Photos",
                                subtitle: "Select existing photos from your library"
                            )
                        }
                    }
                    .padding()
                    
                    Spacer()
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

struct SelectionCard: View {
    let icon: String
    let title: String
    let subtitle: String
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.title)
                .foregroundColor(Theme.accent)
                .frame(width: 40)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(Theme.textPrimary)
                
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundColor(Theme.textSecondary)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(Theme.textSecondary)
        }
        .padding()
        .background(Theme.secondaryBackground)
        .cornerRadius(12)
    }
}

#Preview {
    PhotoCaptureSelectionView(viewModel: PhotoCaptureViewModel())
}