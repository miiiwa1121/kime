import SwiftUI

struct ShutterFlashView: View {
    let isActive: Bool

    var body: some View {
        Color.white
            .ignoresSafeArea()
            .opacity(isActive ? 1 : 0)
            .animation(.easeOut(duration: 0.18), value: isActive)
            .allowsHitTesting(false)
    }
}
