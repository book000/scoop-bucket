# GitHub Copilot Instructions

## プロジェクト概要

- **目的**: 個人用 Scoop バケット (Windows パッケージマネージャー)
- **主な機能**: アプリケーションマニフェストの管理、自動バージョン更新
- **対象ユーザー**: 開発者本人

## 共通ルール

- 会話は日本語で行う。
- コミットメッセージは [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/) に従う。`<description>` は日本語で記載する。
- ブランチ命名は [Conventional Branch](https://conventional-branch.github.io) に従う。`<type>` は短縮形 (feat, fix) を使用する。
- 日本語と英数字の間には半角スペースを入れる。

## 技術スタック

- 言語: PowerShell, JSON
- パッケージマネージャー: Scoop
- CI/CD: GitHub Actions
- テストフレームワーク: Pester 5.2.0+

## コーディング規約

- JSON マニフェストは [Scoop Schema](https://raw.githubusercontent.com/ScoopInstaller/Scoop/master/schema.json) に準拠する。
- JSON フォーマットは `formatjson.ps1` で統一する。
- PowerShell スクリプトは PowerShell 5.1+ と PowerShell Core で動作すること。
- コメントは日本語で記載する。
- エラーメッセージは英語で記載する。

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

## テスト方針

- テストフレームワーク: Pester 5.2.0+
- テストコマンド: `.\bin\test.ps1`
- GitHub Actions で WindowsPowerShell と PowerShell Core の両方でテストを実行する。
- マニフェストの追加・更新時は必ず `checkver.ps1` と `test.ps1` を実行する。

## セキュリティ / 機密情報

- API キーや認証情報を Git にコミットしない。
- ログに個人情報や認証情報を出力しない。
- GitHub Actions の `GITHUB_TOKEN` は自動で提供されるため、シークレットに追加しない。

## ドキュメント更新

マニフェストの追加・更新時は以下を更新する：

- `README.md` の Apps セクションに新規マニフェストを追加する。

## リポジトリ固有

- **Scoop バケット**: JSON マニフェストファイルで Windows アプリケーションのインストールを管理する。
- **マニフェスト配置**: すべてのマニフェストは `bucket/` ディレクトリに配置する。
- **自動更新**: Excavator が 4 時間ごとに自動でバージョン更新の PR を作成する。
- **バージョン管理**: `checkver` フィールドで最新バージョンの検出方法を定義する。
- **autoupdate**: `autoupdate` フィールドで自動更新時の URL パターンを定義する。
- **命名規則**: マニフェストファイル名は原則として小文字を使用するが、アプリケーション名に大文字が含まれる場合はそのまま使用する（例: `jquake.json`, `splashscreen-changer.json`, `ElitesRNGAuraObserver.json`）。
- **必須フィールド**: `version`, `description`, `homepage`, `license`, `url`, `hash` は必須。
- **アーキテクチャ**: 32bit/64bit で異なるバイナリがある場合は `architecture` フィールドを使用する。
- **persist**: 永続化が必要なディレクトリ・ファイルは `persist` フィールドで指定する。
- **shortcuts**: デスクトップショートカットは `shortcuts` フィールドで定義する。
- **bin**: コマンドラインから実行可能にする場合は `bin` フィールドで指定する。
- **pre_install/post_install**: インストール前後の処理が必要な場合は PowerShell スクリプトで定義する。
