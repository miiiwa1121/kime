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
| 姿勢推定 | MediaPipe（Pose Landmarker） | 関節ランドマーク、上半身の傾き、手の位置、距離（bbox） |
| 顔検出・顔向き | Vision Framework | `VNDetectFaceRectanglesRequest`、`VNFaceObservation.roll/yaw/pitch`、目の開閉（landmarks） |
| 触覚 | Core Haptics / UIImpactFeedbackGenerator | 撮影瞬間の振動 |
| 写真保存 | PhotoKit (`PHPhotoLibrary`) | カメラロールへの保存、セッション単位のフォルダ化 |

### 処理設計

- カメラ：30fps 以上を維持
- 姿勢推定：15fps に間引き（重い処理を全フレームで走らせない）
- 推論はバックグラウンドキューで実行、UI 更新のみ MainActor

## データ

| 項目 | MVP（P1） | 将来（P2 以降） |
|---|---|---|
| 状態テンプレート | 手作り 5 個、JSON（`Data/Poses/templates.json`） | コーパスから拡充、将来は embedding |
| 永続化 | JSON 読み込みのみ | SQLite or Realm（必要に応じて） |
| ネットワーク | なし（オンデバイス完結） | 検討余地あり（テンプレ DL 等） |

### 状態テンプレート拡張余地

スキーマには `background_hint`（brightness / clutter）を予約フィールドとして含める。MVP では未使用だが、将来背景認識を入れる際の互換性を確保。詳細は [design.md](design.md) §2 参照。

## ロジック

- **状態一致スコア**（PoseMatcher）：被写体の関節差分 + 顔角度差分 + 構図（フレーム内位置）の重み付き平均。0〜1
- **シルエット補間**（Interpolator）：最近傍テンプレへ 0.1〜0.2 秒で補間。ヒステリシスで切り替え抑制
- **セッション**（CaptureSession）：1 起動 = 5〜10 枚。同じテンプレを連続選択しない
- ルールベースのレコメンドエンジン（タグ一致 + 状況スコアリング、P2 で導入）
- ステートマシン：`SEARCH → GUIDE → CAPTURE`
- スコアの指数移動平均でスムージング

## ビルド・依存管理

- 依存管理：Swift Package Manager（推奨）
  - MediaPipe iOS は CocoaPods が公式だが、SPM 統合方法を要調査
- フォーマッタ・Linter：未導入（必要になったら SwiftLint / swift-format）

## テスト

- 未導入。ロジック層（`Core/Guidance` 等）が固まってきたら XCTest を追加。
- UI テストは P3 以降で検討。

## 非機能要件

- フレームレート：プレビュー 30fps 以上、姿勢推定 15fps
- 発熱・バッテリー消費を抑える（推定間引き、効率的なカメラ設定）
- アプリ起動からカメラ表示まで体感 1 秒以内、人物検出からシルエット出現まで 0.2 秒以内

## 将来候補の周辺技術

- **Apple Watch 連携**：被写体側への振動指示（公共空間で音声が使えない場合の代替）。WatchConnectivity。
- **Core ML**：状態テンプレートの半自動生成、表情ピーク検出（P3 以降）
- **背景認識**：Vision のセグメンテーション or 軽量モデル（P3 以降）
