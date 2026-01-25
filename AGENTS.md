# AI エージェント共通作業方針

## 目的

このドキュメントは、AI エージェント共通の作業方針を定義します。

## 基本方針

- **会話言語**: 日本語
- **コード内コメント**: 日本語
- **エラーメッセージ**: 英語
- **日本語と英数字の間**: 半角スペースを挿入
- **コミットメッセージ**: [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/) に従う
  - `<type>(<scope>): <description>` 形式
  - `<description>` は日本語で記載
  - 例: `feat: JQuake マニフェストを追加`

## 判断記録のルール

判断は必ずレビュー可能な形で記録すること：

1. 判断内容の要約を記載する
2. 検討した代替案を列挙する
3. 採用しなかった案とその理由を明記する
4. 前提条件・仮定・不確実性を明示する
5. 他エージェントによるレビュー可否を示す

前提・仮定・不確実性を明示し、仮定を事実のように扱わない。

## 開発手順（概要）

1. **プロジェクト理解**: リポジトリの構造、目的、技術スタックを理解する
2. **依存関係インストール**: このプロジェクトでは不要（PowerShell スクリプトベース）
3. **変更実装**: マニフェストの追加・更新、PowerShell スクリプトの変更
4. **テストと Lint/Format 実行**: `.\bin\test.ps1` と `.\bin\formatjson.ps1` を実行

## セキュリティ / 機密情報

- API キーや認証情報を Git にコミットしない
- ログに個人情報や認証情報を出力しない
- GitHub Actions の `GITHUB_TOKEN` は自動で提供されるため、シークレットに追加しない

## リポジトリ固有

- **プロジェクト**: 個人用 Scoop バケット (Windows パッケージマネージャー)
- **技術スタック**: PowerShell, JSON, GitHub Actions
- **マニフェスト配置**: すべてのマニフェストは `bucket/` ディレクトリに配置する
- **命名規則**: マニフェストファイル名はアプリケーション名を小文字で記載する
- **必須フィールド**: `version`, `description`, `homepage`, `license`, `url`, `hash` は必須
- **自動更新**: Excavator が 4 時間ごとに自動でバージョン更新の PR を作成する
- **Scoop Schema**: JSON マニフェストは [Scoop Schema](https://raw.githubusercontent.com/ScoopInstaller/Scoop/master/schema.json) に準拠する

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
