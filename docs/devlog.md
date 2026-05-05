# 開発ログ

新しい順に追記。日付は YYYY-MM-DD。

---

## 2026-05-05

### プロジェクト初期セットアップ

- Xcode テンプレートから `kime` プロジェクトを作成（iOS 26.4、Swift 5、SwiftUI）
- ファイル構成を再設計：`App/ Features/ Core/ Data/ Resources/ Supporting/` の 6 ディレクトリ
  - `Core/` 配下に `Camera/Vision/Domain/Guidance/` を分割
  - 各レイヤーに placeholder Swift ファイルを配置
- `ContentView.swift` → `App/AppRoot.swift` にリネーム
- `project.pbxproj` を更新し `PBXFileSystemSynchronizedRootGroup` で 4 つの新ディレクトリを登録
- `.gitignore` を追加（`.DS_Store`、`xcuserdata/`、`DerivedData/` 等）
- `xcodebuild` でビルド成功を確認
- `CameraViewModel` は `@Observable`（iOS 17+）で実装する方針に決定
- `docs/` ディレクトリを作成し `CLAUDE.md`、`devlog.md`、`stack.md`、`roadmap.md` を整備

### 決定事項

- ディレクトリ構成は `src/` でラップしない（iOS 慣習に従い直下配置）
- 非ソースのファイルは将来 `docs/`、`scripts/`、`design/`、`ml/` 等を兄弟ディレクトリとして追加していく
- テストターゲットは未追加（必要になったタイミングで Xcode から追加する）

### 次のステップ

- P1 MVP の着手（カメラプレビュー → MediaPipe 統合 → ポーズ判定 → 自動シャッター）
- 詳細は [roadmap.md](roadmap.md) 参照
