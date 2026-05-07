import SwiftUI

struct ShotThumbnailView: View {
    let isVisible: Bool

    var body: some View {
        RoundedRectangle(cornerRadius: 6)
            .fill(.white.opacity(0.85))
            .frame(width: 44, height: 44)
            .overlay(
                RoundedRectangle(cornerRadius: 6)
                    .stroke(.white, lineWidth: 1.5)
            )
            .shadow(color: .black.opacity(0.4), radius: 6, y: 2)
            .opacity(isVisible ? 1 : 0)
            .scaleEffect(isVisible ? 1 : 0.6)
            .animation(.spring(response: 0.35, dampingFraction: 0.7), value: isVisible)
    }
}
