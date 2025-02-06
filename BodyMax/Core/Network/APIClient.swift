import Foundation
import UIKit

enum APIError: Error {
    case invalidResponse
    case networkError(Error)
    case decodingError(Error)
    case serverError(String)
    case imageProcessingError
}

class APIClient {
    static let shared = APIClient()
    private init() {}
    
    private let session: URLSession = {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 600 // 10 minutes
        config.timeoutIntervalForResource = 600
        return URLSession(configuration: config)
    }()
    
    private func compressImage(_ image: UIImage, maxSizeKB: Int = 75) -> Data? {
        var compression: CGFloat = 1.0
        let maxBytes = maxSizeKB * 1024
        
        guard var imageData = image.jpegData(compressionQuality: compression) else {
            return nil
        }
        
        while imageData.count > maxBytes && compression > 0.1 {
            compression -= 0.1
            if let compressedData = image.jpegData(compressionQuality: compression) {
                imageData = compressedData
            }
        }
        
        return imageData
    }
    
    func analyze(photos: [PhotoType: UIImage], dreamPhysique: UIImage, userProfile: UserProfile) async throws -> Analysis {
        print("APIClient - Starting analysis request")
        
        // Prepare images
        var photoBase64: [String: String] = [:]
        for (type, image) in photos {
            guard let imageData = compressImage(image) else {
                print("APIClient - Failed to compress \(type) image")
                throw APIError.imageProcessingError
            }
            photoBase64[type.rawValue] = imageData.base64EncodedString()
            print("APIClient - Compressed \(type) image")
        }
        
        guard let dreamData = compressImage(dreamPhysique) else {
            print("APIClient - Failed to compress dream physique image")
            throw APIError.imageProcessingError
        }
        
        // Create request
        let request = AnalyzeRequest(
            photos: photoBase64,
            dreamPhysique: dreamData.base64EncodedString(),
            userProfile: UserProfileRequest(from: userProfile)
        )
        
        print("APIClient - Creating URL request")
        var urlRequest = URLRequest(url: Endpoint.analyze(photos: photos, dreamPhysique: dreamPhysique, userProfile: userProfile).url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.timeoutInterval = 600 // Also set at request level
        
        do {
            urlRequest.httpBody = try JSONEncoder().encode(request)
            print("APIClient - Request encoded successfully")
        } catch {
            print("APIClient - Failed to encode request: \(error)")
            throw error
        }
        
        print("APIClient - Sending request to: \(urlRequest.url?.absoluteString ?? "")")
        let (data, response) = try await session.data(for: urlRequest)
        print("APIClient - Received response")
        
        guard let httpResponse = response as? HTTPURLResponse else {
            print("APIClient - Invalid response type")
            throw APIError.invalidResponse
        }
        
        print("APIClient - Status code: \(httpResponse.statusCode)")
        
        guard httpResponse.statusCode == 200 else {
            let errorMessage = String(data: data, encoding: .utf8) ?? "Unknown error"
            print("APIClient - Server error: \(errorMessage)")
            throw APIError.serverError(errorMessage)
        }
        
        do {
            let analysis = try JSONDecoder().decode(Analysis.self, from: data)
            print("APIClient - Successfully decoded response")
            return analysis
        } catch {
            print("APIClient - Failed to decode response: \(error)")
            throw APIError.decodingError(error)
        }
    }
    
    func transform(current: UIImage, dream: UIImage) async throws -> String {
        // Similar update for transform endpoint
        // ... rest of the code ...
        return ""
    }
}
