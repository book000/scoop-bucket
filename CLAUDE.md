# Claude Code 作業方針

## 目的

このドキュメントは、Claude Code がこのプロジェクトで作業する際の方針とプロジェクト固有ルールを示します。

## 判断記録のルール

判断は必ずレビュー可能な形で記録すること：

1. 判断内容の要約
2. 検討した代替案
3. 採用しなかった案とその理由
4. 前提条件・仮定・不確実性
5. 他エージェントによるレビュー可否

前提・仮定・不確実性を明示すること。仮定を事実のように扱ってはならない。

## プロジェクト概要

- **目的**: 個人用 Scoop バケット (Windows パッケージマネージャー)
- **主な機能**: アプリケーションマニフェストの管理、自動バージョン更新
- **対象ユーザー**: 開発者本人

## 重要ルール

- **会話言語**: 日本語
- **コード内コメント**: 日本語
- **エラーメッセージ**: 英語
- **日本語と英数字の間**: 半角スペースを挿入
- **コミットメッセージ**: [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/) に従う
  - `<type>(<scope>): <description>` 形式
  - `<description>` は日本語で記載
  - 例: `feat: JQuake マニフェストを追加`

## 環境のルール

- **ブランチ命名**: [Conventional Branch](https://conventional-branch.github.io) に従う
  - `<type>/<description>` 形式
  - `<type>` は短縮形（feat, fix）を使用
  - 例: `feat/add-jquake-manifest`
- **GitHub リポジトリ調査**: テンポラリディレクトリに `git clone` して検索する
- **Renovate PR**: Renovate が作成した既存の PR に対して、追加コミットや更新を行わない
- **Windows 環境**: Git Bash で動作（PowerShell コマンドは明示的に `powershell -Command ...` か `pwsh -Command ...` を使用）

## コード改修時のルール

- **日本語と英数字の間**: 半角スペースを挿入する
- **エラーメッセージの絵文字**: 既存のエラーメッセージで先頭に絵文字がある場合は、全体で統一する。絵文字はエラーメッセージに即した一文字の絵文字である必要がある。
- **docstring**: 関数やインターフェースには docstring (JSDoc など) を日本語で記載・更新する

## 相談ルール

Codex CLI や Gemini CLI の他エージェントに相談することができます。以下の観点で使い分けてください。

- **Codex CLI (ask-codex)**:
  - 実装コードに対するソースコードレビュー
  - 関数設計、モジュール内部の実装方針などの局所的な技術判断
  - アーキテクチャ、モジュール間契約、パフォーマンス／セキュリティといった全体影響の判断
  - 実装の正当性確認、機械的ミスの検出、既存コードとの整合性確認
- **Gemini CLI (ask-gemini)**:
  - SaaS 仕様、言語・ランタイムのバージョン差、料金・制限・クォータといった、最新の適切な情報が必要な外部依存の判断
  - 外部一次情報の確認、最新仕様の調査、外部前提条件の検証

他エージェントが指摘・異議を提示した場合、Claude Code は必ず以下のいずれかを行う。黙殺・無言での不採用は禁止する。

- 指摘を受け入れ、判断を修正する
- 指摘を退け、その理由を明示する

以下は必ず実施してください。

- 他エージェントの提案を鵜呑みにせず、その根拠や理由を理解する
- 自身の分析結果と他エージェントの意見が異なる場合は、双方の視点を比較検討する
- 最終的な判断は、両者の意見を総合的に評価した上で、自身で下す

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

## アーキテクチャと主要ファイル

### ディレクトリ構成

```
.
├── .github/
│   └── workflows/       # GitHub Actions ワークフロー
├── bin/                 # PowerShell ユーティリティスクリプト
└── bucket/              # Scoop マニフェストファイル (.json)
```

### 主要ファイル

- **bucket/*.json**: Scoop マニフェストファイル。アプリケーションのインストール情報を定義。
- **.github/workflows/ci.yml**: WindowsPowerShell と PowerShell Core でテストを実行する CI ワークフロー。
- **.github/workflows/excavator.yml**: 4 時間ごとに自動でバージョン更新の PR を作成する Excavator ワークフロー。
- **bin/test.ps1**: Pester テストを実行するスクリプト。
- **bin/checkver.ps1**: マニフェストのバージョンチェックを実行するスクリプト。
- **bin/formatjson.ps1**: JSON フォーマットを統一するスクリプト。

## 実装パターン

### 推奨パターン

#### マニフェスト構造

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

#### 32bit/64bit 対応

```json
{
    "architecture": {
        "32bit": {
            "url": "https://example.com/app-32bit.zip",
            "hash": "sha256:..."
        },
        "64bit": {
            "url": "https://example.com/app-64bit.zip",
            "hash": "sha256:..."
        }
    }
}
```

### 非推奨パターン

- マニフェストファイルに大文字を含むファイル名を使用する（例: `JQuake.json` → `jquake.json`）
- `checkver` フィールドを省略する（自動更新ができなくなる）
- `autoupdate` フィールドを省略する（手動更新が必要になる）
- `hash` フィールドを省略する（セキュリティリスク）

## テスト

### テスト方針

- テストフレームワーク: Pester 5.2.0+
- テストコマンド: `.\bin\test.ps1`
- GitHub Actions で WindowsPowerShell と PowerShell Core の両方でテストを実行する

### テスト追加条件

- 新規マニフェストを追加した場合
- 既存マニフェストを更新した場合
- PowerShell スクリプトを変更した場合

テスト実行前に必ず `formatjson.ps1` で JSON フォーマットを統一する。

## ドキュメント更新ルール

### 更新対象

- `README.md`: Apps セクションに新規マニフェストを追加する

### 更新タイミング

- 新規マニフェストを追加したとき
- マニフェストの説明を大幅に変更したとき

## 作業チェックリスト

### 新規改修時

1. プロジェクトについて詳細に探索し理解する
2. 作業を行うブランチが適切であることを確認する（すでに PR を提出しクローズされたブランチでないこと）
3. 最新のリモートブランチに基づいた新規ブランチであることを確認する
4. PR がクローズされ、不要となったブランチは削除されていることを確認する
5. プロジェクトで指定されたパッケージマネージャにより、依存パッケージをインストールする（このプロジェクトでは不要）

### コミット・プッシュ前

1. コミットメッセージが [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/) に従っていることを確認する（`<description>` は日本語で記載）
2. コミット内容にセンシティブな情報が含まれていないことを確認する
3. Lint / Format エラーが発生しないことを確認する（`.\bin\formatjson.ps1` を実行）
4. 動作確認を行い、期待通り動作することを確認する（`.\bin\test.ps1` を実行）

### PR 作成前

1. プルリクエストの作成をユーザーから依頼されていることを確認する
2. コミット内容にセンシティブな情報が含まれていないことを確認する
3. コンフリクトする恐れが無いことを確認する

### PR 作成後

1. コンフリクトが発生していないことを確認する
2. PR 本文の内容は、ブランチの現在の状態を、今までのこの PR での更新履歴を含むことなく、最新の状態のみ、漏れなく日本語で記載されていることを確認する
3. `gh pr checks <PR ID> --watch` で GitHub Actions CI を待ち、その結果がエラーとなっていないことを確認する
4. ローカル環境に `request-review-copilot` コマンドがインストールされている場合（インストール方法や利用手順はこのリポジトリの README または社内ドキュメントを参照）、`request-review-copilot https://github.com/$OWNER/$REPO/pull/$PR_NUMBER` で GitHub Copilot へレビューを依頼する（コマンドが利用できない場合はこの手順はスキップしてよい）
5. 10 分以内に投稿される GitHub Copilot レビューへの対応を行う。対応したら、レビューコメントそれぞれに対して返信を行う
6. `/code-review` コマンドでコードレビューを実施する。スコアが 50 以上の指摘事項に対して対応する

## リポジトリ固有

- **Scoop バケット**: JSON マニフェストファイルで Windows アプリケーションのインストールを管理する
- **マニフェスト配置**: すべてのマニフェストは `bucket/` ディレクトリに配置する
- **自動更新**: Excavator が 4 時間ごとに自動でバージョン更新の PR を作成する
- **バージョン管理**: `checkver` フィールドで最新バージョンの検出方法を定義する
- **autoupdate**: `autoupdate` フィールドで自動更新時の URL パターンを定義する
- **命名規則**: マニフェストファイル名は原則として小文字を使用するが、アプリケーション名に大文字が含まれる場合はそのまま使用する（例: `jquake.json`, `splashscreen-changer.json`, `ElitesRNGAuraObserver.json`）
- **必須フィールド**: `version`, `description`, `homepage`, `license`, `url`, `hash` は必須
- **アーキテクチャ**: 32bit/64bit で異なるバイナリがある場合は `architecture` フィールドを使用する
- **persist**: 永続化が必要なディレクトリ・ファイルは `persist` フィールドで指定する
- **shortcuts**: デスクトップショートカットは `shortcuts` フィールドで定義する
- **bin**: コマンドラインから実行可能にする場合は `bin` フィールドで指定する
- **pre_install/post_install**: インストール前後の処理が必要な場合は PowerShell スクリプトで定義する
- **Scoop Schema**: JSON マニフェストは [Scoop Schema](https://raw.githubusercontent.com/ScoopInstaller/Scoop/master/schema.json) に準拠する
