import SwiftUI

struct CameraGuideView: View {
    let photoType: PhotoType
    @Binding var showGuide: Bool
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Semi-transparent dark overlay
                Color.black.opacity(0.7)
                    .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 0) {
                    // Top instructions
                    VStack(spacing: 8) {
                        Text(photoType.rawValue)
                            .font(.title2)
                            .bold()
                            .foregroundColor(.white)
                        
                        Text(photoType.instructions)
                            .font(.body)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .padding(.bottom, 40)
                    }
                    .padding(.top, 60)
                    .padding(.horizontal)
                    
                    // Camera guide outline
                    Rectangle()
                        .fill(.clear)
                        .frame(
                            width: geometry.size.width * 0.85,
                            height: geometry.size.width * 1.3
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.white.opacity(0.5), style: StrokeStyle(lineWidth: 2, dash: [10]))
                        )
                    
                    Spacer()
                    
                    // Tips and button
                    VStack(spacing: 16) {
                        VStack(alignment: .leading, spacing: 12) {
                            ForEach(PhotoGuide.shared.points, id: \.self) { point in
                                HStack(spacing: 12) {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.green)
                                    Text(point)
                                        .foregroundColor(.white)
                                        .font(.subheadline)
                                }
                            }
                        }
                        .padding(.horizontal)
                        
                        Button {
                            withAnimation {
                                showGuide = false
                            }
                        } label: {
                            Text("Got it")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(width: 160, height: 50)
                                .background(Theme.accent)
                                .cornerRadius(25)
                        }
                        .padding(.vertical, 20)
                    }
                    .padding(.bottom, 50)
                }
            }
        }
    }
}

#Preview {
    ZStack {
        Color.black
        CameraGuideView(photoType: .front, showGuide: .constant(true))
    }
}