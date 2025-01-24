import SwiftUI
import AVFoundation

struct PhotoCaptureView: View {
    @ObservedObject var viewModel: PhotoCaptureViewModel
    @Environment(\.dismiss) private var dismiss
    @StateObject private var cameraManager = CameraManager()
    @State private var showGuide = true
    @State private var showingFlash = false
    @State private var showingProcessingAnimation = false
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            // Camera Preview
            if cameraManager.isCameraAuthorized {
                GeometryReader { geometry in
                    CameraPreviewView(session: cameraManager.session)
                        .ignoresSafeArea()
                }
            } else {
                // Camera permission UI
                VStack(spacing: 20) {
                    Text("Camera Access Required")
                        .font(.title2)
                        .foregroundColor(Theme.textPrimary)
                    
                    Text("Please enable camera access in Settings to take photos")
                        .font(.body)
                        .foregroundColor(Theme.textSecondary)
                        .multilineTextAlignment(.center)
                    
                    Button("Open Settings") {
                        if let url = URL(string: UIApplication.openSettingsURLString) {
                            UIApplication.shared.open(url)
                        }
                    }
                    .foregroundColor(Theme.accent)
                }
                .padding()
            }
            
            // Only show camera controls if guide is not showing
            if !showGuide {
                // Camera controls
                VStack {
                    // Top controls
                    HStack {
                        Button {
                            cameraManager.stopSession()
                            dismiss()
                        } label: {
                            Image(systemName: "xmark")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.white)
                                .frame(width: 40, height: 40)
                                .background(Color.black.opacity(0.6))
                                .clipShape(Circle())
                        }
                        
                        Spacer()
                        
                        Text(viewModel.currentPhotoType.rawValue)
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(Color.black.opacity(0.6))
                            .cornerRadius(20)
                        
                        Spacer()
                        
                        Button {
                            cameraManager.toggleFlash()
                            withAnimation {
                                showingFlash = true
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                    showingFlash = false
                                }
                            }
                        } label: {
                            Image(systemName: cameraManager.flashMode == .on ? "bolt.fill" : "bolt.slash.fill")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.white)
                                .frame(width: 40, height: 40)
                                .background(Color.black.opacity(0.6))
                                .clipShape(Circle())
                        }
                    }
                    .padding()
                    
                    Spacer()
                    
                    // Progress dots
                    HStack(spacing: 8) {
                        ForEach(PhotoType.allCases, id: \.self) { type in
                            Circle()
                                .fill(progressColor(for: type))
                                .frame(width: 8, height: 8)
                        }
                    }
                    .padding(.bottom, 20)
                    
                    // Capture button
                    Button {
                        withAnimation {
                            showingProcessingAnimation = true
                            takePhoto()
                        }
                    } label: {
                        ZStack {
                            Circle()
                                .strokeBorder(Color.white, lineWidth: 3)
                                .frame(width: 74, height: 74)
                            
                            Circle()
                                .fill(Color.white)
                                .frame(width: 66, height: 66)
                        }
                    }
                    .disabled(showingProcessingAnimation)
                    .padding(.bottom, 30)
                }
            }
            
            // Guide overlay
            if showGuide {
                CameraGuideView(
                    photoType: viewModel.currentPhotoType,
                    showGuide: $showGuide
                )
            }
            
            if showingFlash {
                Color.white
                    .ignoresSafeArea()
                    .transition(.opacity)
            }
            
            if showingProcessingAnimation {
                Color.black.opacity(0.7)
                    .ignoresSafeArea()
                    .overlay(
                        ProgressView()
                            .tint(.white)
                            .scaleEffect(1.5)
                    )
            }
        }
        .onAppear {
            DispatchQueue.global(qos: .userInitiated).async {
                cameraManager.startSession()
            }
        }
        .onDisappear {
            cameraManager.stopSession()
        }
    }
    
    private func progressColor(for type: PhotoType) -> Color {
        if viewModel.capturedPhotos[type] != nil {
            return Theme.accent
        } else if type == viewModel.currentPhotoType {
            return .white
        } else {
            return .gray.opacity(0.5)
        }
    }
    
    private func takePhoto() {
        cameraManager.takePhoto { image in
            guard let image = image else {
                DispatchQueue.main.async {
                    showingProcessingAnimation = false
                }
                return
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                viewModel.savePhoto(image, for: viewModel.currentPhotoType)
                
                if viewModel.allPhotosComplete {
                    viewModel.showingReview = true
                    cameraManager.stopSession()
                    dismiss()
                } else {
                    viewModel.moveToNextPhoto()
                    showGuide = true
                }
                
                showingProcessingAnimation = false
            }
        }
    }
}

#Preview {
    PhotoCaptureView(viewModel: PhotoCaptureViewModel())
}