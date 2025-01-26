import SwiftUI
import PhotosUI

struct AnalysisView: View {
    @StateObject private var viewModel = AnalysisViewModel()
    @StateObject private var photoCaptureViewModel: PhotoCaptureViewModel
    
    init() {
        let analysisVM = AnalysisViewModel()
        _viewModel = StateObject(wrappedValue: analysisVM)
        _photoCaptureViewModel = StateObject(wrappedValue: PhotoCaptureViewModel(analysisViewModel: analysisVM))
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Theme.background.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        DreamPhysiqueCard(
                            dreamPhysique: viewModel.dreamPhysique,
                            onAdd: { viewModel.showingPhotoPicker = true },
                            onEdit: { viewModel.showingPhotoPicker = true },
                            onDelete: { viewModel.clearDreamPhysique() }
                        )
                        
                        Button {
                            photoCaptureViewModel.clearAllPhotos()
                            viewModel.startNewAnalysis()
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
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Previous Analyses")
                                .font(.headline)
                                .foregroundColor(Theme.textPrimary)
                            
                            if viewModel.analyses.isEmpty {
                                Text("No analyses yet")
                                    .font(.subheadline)
                                    .foregroundColor(Theme.textSecondary)
                            } else {
                                ForEach(viewModel.analyses, id: \.dateGenerated) { analysis in
                                    Button {
                                        viewModel.selectedAnalysis = analysis
                                        viewModel.showingAnalysisResult = true
                                    } label: {
                                        AnalysisHistoryRow(analysis: analysis)
                                    }
                                }
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding()
                }
            }
            .navigationTitle("Analysis")
            .navigationBarTitleDisplayMode(.inline)
        }
        .sheet(isPresented: $viewModel.showingPhotoPicker) {
            ImagePicker(selectedImage: Binding(
                get: { viewModel.dreamPhysique },
                set: { if let image = $0 { viewModel.saveDreamPhysique(image) } }
            ))
            .preferredColorScheme(.dark)
        }
        .fullScreenCover(isPresented: $viewModel.showingBodyPhotoCapture) {
            PhotoSelectionView(viewModel: photoCaptureViewModel)
        }
        .fullScreenCover(isPresented: $viewModel.showingLoadingView) {
            LoadingView()
        }
        .sheet(isPresented: $viewModel.showingAnalysisResult) {
            if let analysis = viewModel.selectedAnalysis {
                AnalysisResultView(analysis: analysis)
            }
        }
    }
}