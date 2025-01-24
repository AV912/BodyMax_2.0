import SwiftUI
import PhotosUI

struct ImagePicker: View {
    @Binding var selectedImage: UIImage?
    @Environment(\.dismiss) private var dismiss
    @State private var pickerItem: PhotosPickerItem?
    
    var body: some View {
        NavigationView {
            PhotosPicker(
                selection: $pickerItem,
                matching: .images
            ) {
                VStack {
                    Image(systemName: "photo.fill")
                        .font(.system(size: 40))
                        .foregroundColor(Theme.accent)
                    
                    Text("Select Photo")
                        .foregroundColor(Theme.textPrimary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .onChange(of: pickerItem) { item in
                if let item = item {
                    Task {
                        if let data = try? await item.loadTransferable(type: Data.self),
                           let image = UIImage(data: data) {
                            selectedImage = image
                            dismiss()
                        }
                    }
                }
            }
            .navigationTitle("Choose Photo")
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
}

#Preview {
    ImagePicker(selectedImage: .constant(nil))
}