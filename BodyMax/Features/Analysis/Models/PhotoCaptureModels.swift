import SwiftUI

enum PhotoType: String, CaseIterable {
    case front = "Front View"
    case back = "Back View"
    case rightSide = "Right Side"
    case leftSide = "Left Side"
    
    var systemImage: String {
        switch self {
        case .front: return "person.fill"
        case .back: return "person.fill"
        case .rightSide, .leftSide: return "person.fill.turn.right"
        }
    }
    
    var instructions: String {
        switch self {
        case .front:
            return "Stand straight, arms slightly away from body"
        case .back:
            return "Stand straight, back to camera"
        case .rightSide:
            return "Stand sideways, right side to camera"
        case .leftSide:
            return "Stand sideways, left side to camera"
        }
    }
}

struct PhotoGuide {
    let title: String
    let points: [String]
    
    static let shared = PhotoGuide(
        title: "Photo Guidelines",
        points: [
            "Good lighting",
            "Clear background",
            "Stand 6-8 feet from camera",
            "Keep the phone vertical",
            "Ensure image is not blurry"
        ]
    )
}