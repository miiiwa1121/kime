# kime

カメラを向けるだけで、AI がリアルタイムに「盛れる撮り方」をディレクションする iOS カメラアプリ。

ユーザーはポーズを選ばない（ゼロクリック）。アプリが状況に応じて最適なポーズを 1 つ提示し、シルエットと短い指示で誘導、条件達成で自動シャッターを切る。本質は **「撮影体験そのものを代行するアプリ」**。

## 設計思想（必ず守る）

- **ポーズは頻繁に切り替えない** — 一度選んだら維持。状況が大きく変わった時のみ再選択
- **リアルタイム処理は軽量に** — 推定は 15fps に間引く。プレビューは 30fps 以上維持
- **指示は 1〜2 個まで** — 褒めベース（ポジティブ）、UI は極限までシンプル
- **オンデバイス完結** — MVP 段階ではネットワーク依存禁止
- **正確さより気持ちよさ、多機能より一貫性**

## ディレクトリ構成

```
App/                  エントリポイント（KimeApp, AppRoot）
Features/             画面単位（Camera/ など）
Core/
  Camera/             AVFoundation ラッパー
  Vision/             MediaPipe + Vision（姿勢・顔）
  Domain/             モデル（Pose, PoseScore, CaptureState）
  Guidance/           ディレクションロジック（Matcher, Recommender, Feedback, AutoShutter）
Data/                 ポーズ DB（JSON）と Repository
Resources/            Assets.xcassets
Supporting/           Info.plist 等
docs/                 開発ログ・技術スタック・ロードマップ
```

ロジック層（`Core/`）は UI 非依存。テスト可能性を確保する。

## 技術スタック

Swift / SwiftUI / AVFoundation / MediaPipe（Pose）/ Vision（顔）。詳細は [docs/stack.md](docs/stack.md)。

## ステートマシン

`SEARCH → GUIDE → CAPTURE` の 3 状態でユーザー体験を制御する（P2 で実装）。

## 関連ドキュメント

- [docs/roadmap.md](docs/roadmap.md) — フェーズ、タスク、将来像
- [docs/devlog.md](docs/devlog.md) — 開発ログ
- [docs/stack.md](docs/stack.md) — 技術選定の詳細

## 開発時の注意

- ポーズ判定の閾値は厳しすぎないこと（撮影成立を優先）
- 重い AI 処理は同期実行しない
- ポーズを毎フレーム変更しない
- UI を複雑にしない
