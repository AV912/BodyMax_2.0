import SwiftUI

struct RatingView: View {
    @Binding var hasCompleted: Bool
    @State private var rating: Int = 0
    
    var body: some View {
        VStack(spacing: 24) {
            Text("Rate Your Experience")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(Theme.textPrimary)
                .multilineTextAlignment(.center)
            
            Text("Your feedback helps us improve")
                .font(.subheadline)
                .foregroundColor(Theme.textSecondary)
            
            Spacer()
                .frame(height: 40)
            
            HStack(spacing: 20) {
                ForEach(1...5, id: \.self) { star in
                    Image(systemName: rating >= star ? "star.fill" : "star")
                        .font(.system(size: 40))
                        .foregroundColor(rating >= star ? Theme.accent : Theme.textSecondary)
                        .onTapGesture {
                            withAnimation(.spring()) {
                                rating = star
                                hasCompleted = true
                            }
                        }
                }
            }
            
            if rating > 0 {
                Text(ratingMessage)
                    .foregroundColor(Theme.textPrimary)
                    .font(.headline)
                    .padding(.top)
                    .transition(.opacity)
            }
            
            Spacer()
        }
        .padding(.horizontal)
    }
    
    private var ratingMessage: String {
        switch rating {
        case 1:
            return "We'll work hard to improve"
        case 2:
            return "Thanks for your feedback"
        case 3:
            return "We're glad you enjoyed it"
        case 4:
            return "Thanks! We're happy you like it"
        case 5:
            return "Awesome! Thank you!"
        default:
            return ""
        }
    }
}

#Preview {
    ZStack {
        Theme.background.ignoresSafeArea()
        RatingView(hasCompleted: .constant(false))
    }
}