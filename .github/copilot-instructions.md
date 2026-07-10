# GitHub Copilot レビュー指示

個人用 Scoop バケット (Windows パッケージマネージャー) のリポジトリ。中身は `bucket/*.json` の Scoop マニフェストと `bin/*.ps1` の PowerShell ユーティリティ。以下はコードレビュー時の重点確認事項。

## レビュー時の言語

- レビューコメントは日本語で記載する。
- 日本語と英数字の間には半角スペースを入れる。

## マニフェスト (`bucket/*.json`) の確認点

- [Scoop Schema](https://raw.githubusercontent.com/ScoopInstaller/Scoop/master/schema.json) に準拠しているか (`$schema` フィールドを含むこと)。
- 必須フィールドが揃っているか: `version`, `description`, `homepage`, `license`, `url`, `hash`。
- `hash` が欠落・空でないか (欠落はセキュリティ・完全性リスクとして必ず指摘する)。
- `checkver` と `autoupdate` が定義されているか。欠落していると自動バージョン更新ができないため指摘する。
- `autoupdate` の URL パターンが `checkver` で取得するバージョンと整合しているか (`$version` 等のプレースホルダの使い方)。
- 32bit/64bit で異なるバイナリがある場合は `architecture` フィールドを使っているか。

## PowerShell スクリプト (`bin/*.ps1`) の確認点

- Windows PowerShell 5.1 と PowerShell Core の両方で動作するか (CI が両環境でテストするため、片方専用の cmdlet・構文に注意)。
- エラーメッセージは英語、コメントは日本語で記載されているか。

## セキュリティ

- API キー・トークン・パスワード等の機密情報がコミットされていないか。
- `GITHUB_TOKEN` はワークフローに自動提供されるため、シークレットとして追加していないか。

## 誤検知しやすい・指摘不要なパターン

- マニフェストのファイル名にアプリ名由来の大文字が含まれること (例: `ElitesRNGAuraObserver.json`, `ScreenRelay.json`) は意図的。小文字化を一律に求めない。
- マニフェストの `description` が英語で書かれているのは上流アプリの説明文をそのまま採用しているため。日本語化を一律に求めない。
- `$schema` が `ScoopInstaller/Scoop` の `master` を指すのは Scoop バケットの標準的な指定であり問題ない。
- `README.md` の Apps セクションは `bin/update-readme.ps1` により自動生成されるため、手動整形の指摘は不要。

## 良い例 / 悪い例

- 良い: `checkver` と `autoupdate` を備え `hash` が設定されたマニフェスト。
- 悪い: `hash` や `checkver` を省略したマニフェスト (自動更新不可・完全性未検証)。
