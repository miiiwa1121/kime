import SwiftUI

struct CameraScreen: View {
    @State private var viewModel = CameraViewModel()

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            if showSilhouette {
                SilhouetteView()
                    .transition(.opacity)
            }

            VStack {
                topBar
                    .padding(.horizontal, 16)
                    .padding(.top, 8)
                Spacer()
                bottomBar
                    .padding(.horizontal, 24)
                    .padding(.bottom, 32)
            }

            ShutterFlashView(isActive: viewModel.showFlash)
        }
        .animation(.easeInOut(duration: 0.3), value: showSilhouette)
        .onAppear { viewModel.start() }
        .onDisappear { viewModel.stop() }
        .statusBarHidden()
    }

    private var topBar: some View {
        ZStack {
            if !viewModel.feedbackText.isEmpty {
                FeedbackView(text: viewModel.feedbackText)
            }
            HStack {
                Spacer()
                AIToggleButton(isOn: viewModel.isAIShutterEnabled) {
                    viewModel.toggleAIShutter()
                }
            }
        }
    }

    private var bottomBar: some View {
        ZStack {
            HStack {
                ShotThumbnailView(isVisible: viewModel.showThumbnail)
                Spacer()
            }
            ShutterButton(action: viewModel.manualCapture)
        }
    }

    private var showSilhouette: Bool {
        viewModel.captureState == .guiding
    }
}

#Preview {
    CameraScreen()
}
