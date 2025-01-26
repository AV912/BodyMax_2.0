import SwiftUI

struct CameraGuideView: View {
    let photoType: PhotoType
    @Binding var showGuide: Bool
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.8).ignoresSafeArea()
            
            VStack(spacing: 24) {
                Spacer()
                
                // Title and Instructions
                VStack(spacing: 12) {
                    Text(photoType.rawValue)
                        .font(.title2)
                        .bold()
                        .foregroundColor(.white)
                    
                    Text(photoType.instructions)
                        .font(.body)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                }
                .padding()
                
                // Photo Guidelines
                VStack(spacing: 16) {
                    ForEach(PhotoGuide.shared.points, id: \.self) { point in
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                            Text(point)
                                .foregroundColor(.white)
                        }
                    }
                }
                .padding()
                
                Spacer()
                
                // Got it Button
                Button {
                    withAnimation {
                        showGuide = false
                    }
                } label: {
                    Text("Got it")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(Theme.accent)
                        .cornerRadius(28)
                }
                .padding()
            }
        }
    }
}

#Preview {
    CameraGuideView(photoType: .front, showGuide: .constant(true))
}