# README.md の Apps セクションを bucket/ 配下のマニフェストから自動生成するスクリプト

$bucketDir = Join-Path $PSScriptRoot '..\bucket'
$readmePath = Join-Path $PSScriptRoot '..\README.md'

# マニフェストを取得してアプリ名でソート
$manifests = Get-ChildItem -Path $bucketDir -Filter '*.json' | Sort-Object Name

# Apps セクションの内容を生成
$appLines = foreach ($manifest in $manifests) {
    $json = Get-Content $manifest.FullName -Raw | ConvertFrom-Json
    $appName = [System.IO.Path]::GetFileNameWithoutExtension($manifest.Name)
    $homepage = $json.homepage
    $version = $json.version
    "- [$appName]($homepage): $version"
}

# README.md を行単位で読み込み
$lines = Get-Content $readmePath

# Apps セクションの開始行と次のセクションの開始行を検索
$appsStart = -1
$nextSectionStart = -1

for ($i = 0; $i -lt $lines.Count; $i++) {
    if ($lines[$i] -eq '## Apps') {
        $appsStart = $i
    } elseif ($appsStart -ge 0 -and $lines[$i] -match '^##\s') {
        $nextSectionStart = $i
        break
    }
}

if ($appsStart -lt 0) {
    Write-Error "README.md に '## Apps' セクションが見つかりませんでした。"
    exit 1
}

# 新しい Apps セクションを構築
$newSection = @('## Apps', '')
$newSection += $appLines

# README.md の内容を再構築
if ($nextSectionStart -ge 0) {
    # Apps セクションの後に別のセクションが存在する場合
    $newLines = $lines[0..($appsStart - 1)] + $newSection + @('') + $lines[$nextSectionStart..($lines.Count - 1)]
} else {
    # Apps セクションが末尾の場合
    $newLines = $lines[0..($appsStart - 1)] + $newSection
}

# ファイルに書き戻す（末尾に改行を付ける）
$content = ($newLines -join "`n") + "`n"
[System.IO.File]::WriteAllText($readmePath, $content)

Write-Host "README.md の Apps セクションを更新しました。"
