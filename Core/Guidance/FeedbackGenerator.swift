import Foundation

enum FeedbackGenerator {
    static func text(for score: Double) -> String {
        switch score {
        case ..<0.4:
            return ["もう少し右！", "あごを引いて", "肩おろして"].randomElement() ?? ""
        case ..<0.7:
            return ["いい感じ！", "そのまま！", "近づいてる"].randomElement() ?? ""
        default:
            return ["ベスト！", "今の好き！", "完璧！"].randomElement() ?? ""
        }
    }
}
