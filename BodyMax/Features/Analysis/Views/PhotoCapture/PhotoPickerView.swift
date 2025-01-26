import SwiftUI
import PhotosUI

struct PhotoPickerView: View {
    @ObservedObject var viewModel: PhotoCaptureViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var selectedItem: PhotosPickerItem?
    
    var body: some View {
        NavigationView {
            ZStack {
                Theme.background.ignoresSafeArea()
                
                PhotosPicker(
                    selection: $selectedItem,
                    matching: .images
                ) {
                    VStack(spacing: 20) {
                        Image(systemName: "photo.fill")
                            .font(.system(size: 48))
                            .foregroundColor(Theme.textSecondary)
                        
                        Text("Select Photo")
                            .font(.headline)
                            .foregroundColor(Theme.textPrimary)
                    }
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
        }
        .onChange(of: selectedItem) { item in
            Task {
                if let data = try? await item?.loadTransferable(type: Data.self),
                   let image = UIImage(data: data) {
                    viewModel.savePhoto(image, for: viewModel.currentPhotoType)
                    dismiss()
                }
            }
        }
    }
}

#Preview {
    PhotoPickerView(viewModel: PhotoCaptureViewModel(analysisViewModel: AnalysisViewModel()))
}