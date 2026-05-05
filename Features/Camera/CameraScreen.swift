import SwiftUI

struct CameraScreen: View {
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            Text("Camera")
                .foregroundStyle(.white)
        }
    }
}

#Preview {
    CameraScreen()
}
