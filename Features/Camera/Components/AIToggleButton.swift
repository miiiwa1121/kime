import SwiftUI

struct AIToggleButton: View {
    let isOn: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(systemName: "sparkles")
                    .font(.system(size: 13, weight: .semibold))
                Text(isOn ? "AI ON" : "AI OFF")
                    .font(.system(size: 13, weight: .semibold, design: .rounded))
            }
            .foregroundStyle(isOn ? .black : .white.opacity(0.85))
            .padding(.horizontal, 14)
            .padding(.vertical, 9)
            .background(
                ZStack {
                    Capsule().fill(isOn ? Color.white.opacity(0.9) : Color.clear)
                    Capsule().stroke(.white.opacity(isOn ? 0 : 0.5), lineWidth: 1.2)
                }
            )
        }
        .buttonStyle(.plain)
        .animation(.easeInOut(duration: 0.18), value: isOn)
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        VStack(spacing: 20) {
            AIToggleButton(isOn: true) {}
            AIToggleButton(isOn: false) {}
        }
    }
}
