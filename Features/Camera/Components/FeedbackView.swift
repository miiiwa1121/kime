import SwiftUI

struct FeedbackView: View {
    let text: String

    var body: some View {
        Text(text)
            .font(.system(size: 16, weight: .medium, design: .rounded))
            .foregroundStyle(.white.opacity(0.9))
            .shadow(color: .black.opacity(0.6), radius: 4, y: 1)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(.black.opacity(0.2), in: Capsule())
            .animation(.easeInOut(duration: 0.25), value: text)
            .id(text)
            .transition(.opacity.combined(with: .scale(scale: 0.95)))
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        FeedbackView(text: "いい感じ！")
    }
}
