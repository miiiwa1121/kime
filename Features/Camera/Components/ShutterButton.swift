import SwiftUI

struct ShutterButton: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            ZStack {
                Circle()
                    .stroke(.white.opacity(0.7), lineWidth: 3)
                    .frame(width: 68, height: 68)
                Circle()
                    .fill(.white.opacity(0.9))
                    .frame(width: 56, height: 56)
            }
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        ShutterButton {}
    }
}
