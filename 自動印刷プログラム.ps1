# ===============================================
# 処方せん自動印刷プログラム（本店仕様：完全自動・PDF・回転対応！）
# ===============================================
Add-Type -AssemblyName System.Drawing

# 💡【設定】使用するプリンター名（店舗の環境に合わせて設定済み）
$printerName = "TASKalfa 408ci(J)"

# 💡【設定】見張るフォルダのリスト（ショートカットIDのパス）
# フォルダ名が変更されても自動追従するようにIDで指定します
$watchTargets = @(
    "G:\.shortcut-targets-by-id\1XKAv_L2hOGBZXKR7Q2exjpZsUKniPoD3",
    "G:\.shortcut-targets-by-id\1AWpZQwtF2VusSpJf9PF3OnurIdrHI6uj"
)

# 各フォルダの「印刷済み」準備
foreach ($target in $watchTargets) {
    if (Test-Path $target) {
        $folder = Get-ChildItem -Path $target -Directory | Select-Object -First 1
        if ($folder) {
            $printedFolder = Join-Path $folder.FullName "印刷済み"
            if (-not (Test-Path $printedFolder)) { New-Item -ItemType Directory -Path $printedFolder | Out-Null }
        }
    }
}

Write-Host "==============================================="
Write-Host "  クローバー調剤薬局さま専用"
Write-Host "  自動印刷プログラム 稼働中...（完全自動）🍵"
Write-Host "==============================================="
Write-Host ""
Write-Host "👀 新しいファイルが Google ドライブ に届くのを見張っています..."

while ($true) {
    foreach ($target in $watchTargets) {
        if (-not (Test-Path $target)) { continue }
        
        # 実際のフォルダ名（アンケートやGoogleフォーム等）を動的に取得
        $folder = Get-ChildItem -Path $target -Directory | Select-Object -First 1
        if (-not $folder) { continue }
        
        $watchFolder = $folder.FullName
        $printedFolder = Join-Path $watchFolder "印刷済み"
        
        # 印刷済みフォルダがない場合は作成
        if (-not (Test-Path $printedFolder)) { New-Item -ItemType Directory -Path $printedFolder | Out-Null }
        
        # フォルダ内の JPG, PNG, PDFを探す
        $files = Get-ChildItem -Path $watchFolder -File | Where-Object { $_.Extension -match '\.(jpg|png|jpeg|pdf)$' }
        
        foreach ($file in $files) {
            Write-Host ("📄 ファイルを発見しました: " + $file.Name)
            $target = Join-Path $printedFolder $file.Name
            
            try {
                # 1. 印刷済みフォルダへ移動
                Move-Item -Path $file.FullName -Destination $target -ErrorAction Stop
                Write-Host "🚚 「印刷済み」フォルダに移動しました。"
                
                # 2. 印刷処理
                if ($file.Extension -match '\.pdf$') {
                    # PDFの場合：Windows標準の印刷コマンドを使用
                    Write-Host "🖨️ PDFを印刷しています..."
                    Start-Process -FilePath $target -Verb Print -Wait
                } else {
                    # 画像の場合：回転補正
                    Write-Host "🔄 画像の向きを補正しています..."
                    $img = [System.Drawing.Image]::FromFile($target)
                    if ($img.Width -gt $img.Height) {
                        # 横長なら 90度回転させて縦にする
                        $img.RotateFlip([System.Drawing.RotateFlipType]::Rotate90FlipNone)
                        $img.Save($target, $img.RawFormat) # 元の形式で保存
                        Write-Host "🔄 横長だったので縦に回転させました。"
                    }
                    $img.Dispose()
                    
                    # 印刷：rundll32 を使って画面を出さずにプリンターに直送
                    Write-Host "🖨️ 画像を自動印刷しています..."
                    $arg = "C:\Windows\System32\shimgvw.dll,ImageView_PrintTo `"$target`" `"$printerName`""
                    Start-Process "rundll32.exe" -ArgumentList $arg -Wait
                }
                Write-Host "✨ 印刷完了！"
                Write-Host ""
            } catch {
                Write-Warning "⚠️ 処理中にエラーが発生しました:"
                Write-Host $_.Exception.Message
                Write-Host "⏳ 5秒後に再試行します..."
            }
        }
    }
    # 5秒待機
    Start-Sleep -Seconds 5
}
