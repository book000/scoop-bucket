# Gemini CLI 作業方針

## 目的

このドキュメントは、Gemini CLI 向けのコンテキストと作業方針を定義します。

## 出力スタイル

- **言語**: 日本語で応答する
- **トーン**: 技術的で簡潔、明確な説明を心がける
- **形式**: Markdown 形式で出力する

## 共通ルール

- **会話言語**: 日本語
- **コード内コメント**: 日本語
- **エラーメッセージ**: 英語
- **日本語と英数字の間**: 半角スペースを挿入
- **コミットメッセージ**: [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/) に従う
  - `<type>(<scope>): <description>` 形式
  - `<description>` は日本語で記載
  - 例: `feat: JQuake マニフェストを追加`
- **ブランチ命名**: [Conventional Branch](https://conventional-branch.github.io) に従う
  - `<type>/<description>` 形式
  - `<type>` は短縮形（feat, fix）を使用
  - 例: `feat/add-jquake-manifest`

## プロジェクト概要

- **目的**: 個人用 Scoop バケット (Windows パッケージマネージャー)
- **主な機能**: アプリケーションマニフェストの管理、自動バージョン更新
- **対象ユーザー**: 開発者本人

## コーディング規約

- **JSON マニフェスト**: [Scoop Schema](https://raw.githubusercontent.com/ScoopInstaller/Scoop/master/schema.json) に準拠する
- **JSON フォーマット**: `formatjson.ps1` で統一する
- **PowerShell スクリプト**: PowerShell 5.1+ と PowerShell Core で動作すること
- **コメント言語**: 日本語
- **エラーメッセージ言語**: 英語

## 開発コマンド

```powershell
# マニフェストのバージョンチェック
.\bin\checkver.ps1

# マニフェストの URL チェック
.\bin\checkurls.ps1

# マニフェストのハッシュチェック
.\bin\checkhashes.ps1

# JSON フォーマット
.\bin\formatjson.ps1

# テスト実行 (Pester)
.\bin\test.ps1

# 自動 PR 作成
.\bin\auto-pr.ps1

# checkver が未定義のマニフェストを検出
.\bin\missing-checkver.ps1
```

## 注意事項

- **認証情報**: API キーや認証情報を Git にコミットしない
- **ログ**: 個人情報や認証情報をログに出力しない
- **既存ルール**: プロジェクトの既存コーディング規約を優先する
- **既知の制約**:
  - Scoop バケットは JSON マニフェストで構成される
  - Excavator が 4 時間ごとに自動でバージョン更新の PR を作成する
  - テストは WindowsPowerShell と PowerShell Core の両方で実行される

## リポジトリ固有

- **Scoop バケット**: JSON マニフェストファイルで Windows アプリケーションのインストールを管理する
- **マニフェスト配置**: すべてのマニフェストは `bucket/` ディレクトリに配置する
- **命名規則**: マニフェストファイル名はアプリケーション名を小文字で記載する（例: `jquake.json`, `splashscreen-changer.json`）
- **必須フィールド**: `version`, `description`, `homepage`, `license`, `url`, `hash` は必須
- **アーキテクチャ**: 32bit/64bit で異なるバイナリがある場合は `architecture` フィールドを使用する
- **persist**: 永続化が必要なディレクトリ・ファイルは `persist` フィールドで指定する
- **shortcuts**: デスクトップショートカットは `shortcuts` フィールドで定義する
- **bin**: コマンドラインから実行可能にする場合は `bin` フィールドで指定する
- **pre_install/post_install**: インストール前後の処理が必要な場合は PowerShell スクリプトで定義する
- **checkver**: `checkver` フィールドで最新バージョンの検出方法を定義する
- **autoupdate**: `autoupdate` フィールドで自動更新時の URL パターンを定義する
- **Scoop Schema**: JSON マニフェストは [Scoop Schema](https://raw.githubusercontent.com/ScoopInstaller/Scoop/master/schema.json) に準拠する

## マニフェスト構造例

```json
{
    "$schema": "https://raw.githubusercontent.com/ScoopInstaller/Scoop/master/schema.json",
    "version": "1.0.0",
    "description": "アプリケーションの説明",
    "homepage": "https://example.com/",
    "license": "MIT",
    "url": "https://example.com/download/app-1.0.0.zip",
    "hash": "sha256:...",
    "bin": "app.exe",
    "shortcuts": [
        [
            "app.exe",
            "App Name"
        ]
    ],
    "persist": ["config", "data"],
    "checkver": {
        "url": "https://api.github.com/repos/owner/repo/releases/latest",
        "jsonpath": "$.tag_name"
    },
    "autoupdate": {
        "url": "https://example.com/download/app-$version.zip"
    }
}
```

## Gemini CLI の役割

Gemini CLI は以下の役割を担います：

- **外部仕様の確認**: SaaS 仕様、言語・ランタイムのバージョン差、料金・制限・クォータなどの最新情報の確認
- **一次情報の調査**: Scoop の最新仕様、GitHub Actions の最新機能、Pester の最新バージョンなどの調査
- **外部依存の検証**: 外部 API やサービスの仕様変更の確認

Gemini CLI はナレッジカットオフの範囲内で公開情報や公式ドキュメントを参照できるため、以下のような質問に比較的最近の情報を元に回答するのに適しています：

- 「Scoop の最新バージョンは何ですか？」
- 「Pester 5.2.0 の新機能は何ですか？」
- 「GitHub Actions の最新の推奨事項は何ですか？」
