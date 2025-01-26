import SwiftUI

struct NumberPickerView: View {
    @Binding var selectedNumber: Int
    let range: ClosedRange<Int>
    let title: String
    let subtitle: String?
    
    var body: some View {
        VStack(spacing: 24) {
            Text(title)
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(Theme.textPrimary)
                .multilineTextAlignment(.center)
            
            if let subtitle = subtitle {
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundColor(Theme.textSecondary)
            }
            
            ScrollViewReader { proxy in
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVStack(spacing: 8) {
                        ForEach(range.map { $0 }, id: \.self) { number in
                            Text("\(number)")
                                .font(.system(size: number == selectedNumber ? 36 : 24))
                                .fontWeight(number == selectedNumber ? .bold : .regular)
                                .foregroundColor(number == selectedNumber ? Theme.textPrimary : Theme.textSecondary.opacity(0.5))
                                .frame(height: 44)
                                .id(number)
                                .onTapGesture {
                                    withAnimation {
                                        selectedNumber = number
                                        proxy.scrollTo(number, anchor: .center)
                                    }
                                }
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
                .frame(height: 220)
                .mask(
                    LinearGradient(
                        gradient: Gradient(
                            stops: [
                                .init(color: .clear, location: 0),
                                .init(color: .black, location: 0.1),
                                .init(color: .black, location: 0.9),
                                .init(color: .clear, location: 1)
                            ]
                        ),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .overlay(
                    Rectangle()
                        .fill(Theme.accent.opacity(0.1))
                        .frame(height: 44)
                )
                .onChange(of: selectedNumber) { newValue in
                    withAnimation {
                        proxy.scrollTo(newValue, anchor: .center)
                    }
                }
                .onAppear {
                    proxy.scrollTo(selectedNumber, anchor: .center)
                }
            }
        }
        .padding(.horizontal)
    }
}

#Preview {
    ZStack {
        Theme.background.ignoresSafeArea()
        NumberPickerView(
            selectedNumber: .constant(25),
            range: 18...100,
            title: "How old are you?",
            subtitle: "This helps us create your personalized plan"
        )
    }
}