import SwiftUI
import PhotosUI

struct PhotoPickerView: View {
    @ObservedObject var viewModel: PhotoCaptureViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                Theme.background.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        ForEach(PhotoType.allCases, id: \.self) { type in
                            VStack {
                                PhotosPicker(
                                    selection: .init(
                                        get: { nil },
                                        set: { item in
                                            if let item = item {
                                                loadImage(item: item, for: type)
                                            }
                                        }
                                    ),
                                    matching: .images,
                                    photoLibrary: .shared()
                                ) {
                                    PhotoSelectionRow(
                                        type: type,
                                        image: viewModel.capturedPhotos[type],
                                        onSelect: { }
                                    )
                                }
                            }
                        }
                        
                        if viewModel.allPhotosComplete {
                            Button {
                                viewModel.showingReview = true
                            } label: {
                                Text("Continue")
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
            .navigationTitle("Upload Photos")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func loadImage(item: PhotosPickerItem, for type: PhotoType) {
        Task {
            if let data = try? await item.loadTransferable(type: Data.self),
               let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    viewModel.savePhoto(image, for: type)
                }
            }
        }
    }
}

struct PhotoSelectionRow: View {
    let type: PhotoType
    let image: UIImage?
    let onSelect: () -> Void
    
    var body: some View {
        HStack(spacing: 16) {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 60, height: 60)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            } else {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Theme.secondaryBackground)
                    .frame(width: 60, height: 60)
                    .overlay(
                        Image(systemName: "plus")
                            .foregroundColor(Theme.textSecondary)
                    )
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(type.rawValue)
                    .font(.headline)
                    .foregroundColor(Theme.textPrimary)
                
                Text(image == nil ? "Select photo" : "Change photo")
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
    PhotoPickerView(viewModel: PhotoCaptureViewModel())
}