import SwiftUI
import PhotosUI

struct AnalysisView: View {
    @StateObject private var viewModel = AnalysisViewModel()
    @StateObject private var photoCaptureViewModel = PhotoCaptureViewModel()
    
    var body: some View {
        NavigationView {
            ZStack {
                Theme.background.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        // Dream Physique Card
                        DreamPhysiqueCard(
                            dreamPhysique: viewModel.dreamPhysique,
                            onAdd: { viewModel.showingPhotoPicker = true },
                            onEdit: { viewModel.showingPhotoPicker = true },
                            onDelete: { viewModel.clearDreamPhysique() }
                        )
                        
                        // New Analysis Button
                        Button {
                            photoCaptureViewModel.clearAllPhotos()
                            viewModel.showingBodyPhotoCapture = true
                        } label: {
                            HStack {
                                Image(systemName: "camera.fill")
                                Text("Start New Analysis")
                            }
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(viewModel.dreamPhysique != nil ? Theme.accent : Theme.accent.opacity(0.5))
                            .cornerRadius(28)
                        }
                        .disabled(viewModel.dreamPhysique == nil)
                        
                        // Previous Analyses
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Previous Analyses")
                                .font(.headline)
                                .foregroundColor(Theme.textPrimary)
                            
                            if true {
                                Text("No analyses yet")
                                    .font(.subheadline)
                                    .foregroundColor(Theme.textSecondary)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding()
                }
            }
            .navigationTitle("Analysis")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $viewModel.showingPhotoPicker) {
                ImagePicker(selectedImage: Binding(
                    get: { viewModel.dreamPhysique },
                    set: { if let image = $0 { viewModel.saveDreamPhysique(image) } }
                ))
                .preferredColorScheme(.dark)
            }
            .sheet(isPresented: $viewModel.showingBodyPhotoCapture) {
                RequiredPhotosView(viewModel: photoCaptureViewModel)
            }
        }
    }
}

struct DreamPhysiqueCard: View {
    let dreamPhysique: UIImage?
    let onAdd: () -> Void
    let onEdit: () -> Void
    let onDelete: () -> Void
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text("Dream Physique")
                    .font(.headline)
                    .foregroundColor(Theme.textPrimary)
                Spacer()
                if dreamPhysique != nil {
                    Menu {
                        Button(action: onEdit) {
                            Label("Change Photo", systemImage: "photo")
                        }
                        Button(role: .destructive, action: onDelete) {
                            Label("Remove Photo", systemImage: "trash")
                        }
                    } label: {
                        Image(systemName: "ellipsis")
                            .foregroundColor(Theme.textSecondary)
                            .padding(8)
                    }
                }
            }
            
            if let image = dreamPhysique {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                    .cornerRadius(12)
                    .clipped()
            } else {
                Button(action: onAdd) {
                    VStack(spacing: 12) {
                        Image(systemName: "photo.fill")
                            .font(.system(size: 40))
                        Text("Upload Dream Physique")
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
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Theme.secondaryBackground)
        .cornerRadius(12)
    }
}

#Preview {
    AnalysisView()
}