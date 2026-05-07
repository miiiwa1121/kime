import Foundation
import Observation
import UIKit
import AudioToolbox

@MainActor
@Observable
final class CameraViewModel {
    var captureState: CaptureState = .idle
    var score: Double = 0
    var feedbackText: String = ""
    var showFlash: Bool = false
    var showThumbnail: Bool = false
    var totalShotCount: Int = 0
    var isAIShutterEnabled: Bool = true

    private var liveTask: Task<Void, Never>?
    private var isCapturing: Bool = false

    func start() {
        liveTask?.cancel()
        liveTask = Task { await runLive() }
    }

    func stop() {
        liveTask?.cancel()
        liveTask = nil
        captureState = .idle
    }

    func toggleAIShutter() {
        isAIShutterEnabled.toggle()
    }

    func manualCapture() {
        Task { await captureMoment() }
    }

    private func runLive() async {
        captureState = .searching
        try? await Task.sleep(for: .milliseconds(500))
        if Task.isCancelled { return }

        captureState = .guiding

        while !Task.isCancelled {
            await runScoringLoop()
            if Task.isCancelled { return }
            await captureMoment()
        }
    }

    private func runScoringLoop() async {
        let start = Date()
        var holdStart: Date?
        var feedbackRefreshAt: Double = 0
        score = 0.15

        while !Task.isCancelled {
            try? await Task.sleep(for: .milliseconds(33))
            let t = Date().timeIntervalSince(start)
            let baseRise = min(t * 0.3, 0.92)
            let noise = sin(t * 5) * 0.06 + Double.random(in: -0.02...0.02)
            score = max(0, min(1, baseRise + noise))

            if t - feedbackRefreshAt > 0.6 {
                feedbackText = FeedbackGenerator.text(for: score)
                feedbackRefreshAt = t
            }

            if score >= 0.75 {
                if holdStart == nil {
                    holdStart = Date()
                } else if isAIShutterEnabled,
                          Date().timeIntervalSince(holdStart!) >= 0.5 {
                    return
                }
            } else {
                holdStart = nil
            }
        }
    }

    private func captureMoment() async {
        guard !isCapturing else { return }
        isCapturing = true
        defer { isCapturing = false }

        showFlash = true
        UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
        AudioServicesPlaySystemSound(1108)
        totalShotCount += 1
        print("[Kime] Shot \(totalShotCount) saved (mock)")

        try? await Task.sleep(for: .milliseconds(120))
        showFlash = false

        showThumbnail = true
    }
}
