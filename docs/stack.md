# 技術スタック

## プラットフォーム

| 項目 | 選定 | 備考 |
|---|---|---|
| OS | iOS（ネイティブ） | 16:9 / 9:16 のカメラ性能、Vision の活用 |
| 最小サポート | iOS 26.4 | Xcode テンプレート初期値（要見直し） |
| 言語 | Swift 5 | `SWIFT_DEFAULT_ACTOR_ISOLATION = MainActor` 採用 |

## UI

| 項目 | 選定 | 理由 |
|---|---|---|
| UI フレームワーク | SwiftUI | 宣言的、状態駆動、開発速度 |
| 状態管理 | `@Observable`（Observation） | iOS 17+ の新 API、`ObservableObject` より軽量 |

## カメラ・コンピュータビジョン

| 項目 | 選定 | 用途 |
|---|---|---|
| カメラ | AVFoundation | プレビュー表示、フレーム取得（CMSampleBuffer） |
| 姿勢推定 | MediaPipe（Pose Landmarker） | 関節ランドマーク取得（肩・首・顔・全身） |
| 顔検出・顔向き | Vision Framework | `VNDetectFaceRectanglesRequest`、`VNFaceObservation.roll/yaw/pitch` |

### 処理設計

- カメラ：30fps 以上を維持
- 姿勢推定：15fps に間引き（重い処理を全フレームで走らせない）
- 推論はバックグラウンドキューで実行、UI 更新のみ MainActor

## データ

| 項目 | MVP（P1） | 将来（P2 以降） |
|---|---|---|
| ポーズ定義 | ハードコード（1 ポーズ） | JSON ファイル（`Data/Poses/poses.json`） |
| 永続化 | なし | SQLite or Realm（必要に応じて） |
| ネットワーク | なし（オンデバイス完結） | 検討余地あり（ポーズ DL 等） |

## ロジック

- ルールベースのレコメンドエンジン（タグ一致 + 状況スコアリング）
- ポーズ一致度：関節差分の重み付き平均、0〜1 のスコア
- ステートマシン：`SEARCH → GUIDE → CAPTURE`
- スコアスムージング（揺らぎ抑制）

## ビルド・依存管理

- 依存管理：Swift Package Manager（推奨）
  - MediaPipe iOS は CocoaPods が公式だが、SPM 統合方法を要調査
- フォーマッタ・Linter：未導入（必要になったら SwiftLint / swift-format）

## テスト

- 未導入。ロジック層（`Core/Guidance` 等）が固まってきたら XCTest を追加。
- UI テストは P3 以降で検討。

## 非機能要件

- フレームレート：最低 30fps
- 発熱・バッテリー消費を抑える（推定間引き、効率的なカメラ設定）
- アプリ起動からカメラ表示まで体感 1 秒以内を目標
