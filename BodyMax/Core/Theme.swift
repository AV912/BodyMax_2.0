import SwiftUI

enum Theme {
    // MARK: - Colors
    static let background = Color(hex: "121212") // Very dark background
    static let secondaryBackground = Color(hex: "1E1E1E") // Slightly lighter background for cards
    static let accent = Color(hex: "9B6DFF") // Purple accent color
    static let secondaryAccent = Color(hex: "7B4DFF") // Darker purple for gradients
    static let textPrimary = Color.white
    static let textSecondary = Color.gray
    
    // MARK: - Corner Radius
    static let cornerRadius: CGFloat = 16
    static let buttonCornerRadius: CGFloat = 25
    
    // MARK: - Padding
    static let padding: CGFloat = 16
    static let smallPadding: CGFloat = 8
    static let largePadding: CGFloat = 24
    
    // MARK: - Button Style
    static func primaryButton() -> some View {
        AnyView(
            ModifiedContent(
                content: Theme.accent,
                modifier: RoundedCornerStyle(radius: buttonCornerRadius)
            )
        )
    }
    
    // MARK: - Card Style
    static var cardStyle: some ViewModifier {
        CardModifier()
    }
}

// MARK: - Helper Extensions
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// MARK: - Custom Modifiers
struct CardModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(Theme.secondaryBackground)
            .cornerRadius(Theme.cornerRadius)
            .shadow(radius: 5)
    }
}

struct RoundedCornerStyle: ViewModifier {
    var radius: CGFloat
    
    func body(content: Content) -> some View {
        content
            .cornerRadius(radius)
    }
}
