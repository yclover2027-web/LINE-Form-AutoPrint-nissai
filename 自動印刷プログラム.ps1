# ===============================================
# 処方せん自動印刷プログラム（本店仕様：複数フォルダ・PDF・回転対応）
# ===============================================
Add-Type -AssemblyName System.Drawing

# 💡【設定】見張るフォルダのリスト（にっさい店用）
$watchFolders = @(
    "G:\.shortcut-targets-by-id\1XKAv_L2hOGBZXKR7Q2exjpZsUKniPoD3\処方せん受信トレイ　にっさい",
    "G:\.shortcut-targets-by-id\1AWpZQwtF2VusSpJf9PF3OnurIdrHI6uj\アンケートにっさい"
)

# 各フォルダの準備
foreach ($folder in $watchFolders) {
    $printedFolder = Join-Path $folder "印刷済み"
    if (-not (Test-Path $printedFolder)) { New-Item -ItemType Directory -Path $printedFolder | Out-Null }
}

Write-Host "==============================================="
Write-Host "  クローバー調剤薬局さま専用"
Write-Host "  自動印刷プログラム（複数フォルダ監視中）🍵"
Write-Host "==============================================="
Write-Host ""
Write-Host "👀 新しいファイルが Google ドライブ に届くのを見張っています..."

while ($true) {
    foreach ($watchFolder in $watchFolders) {
        $printedFolder = Join-Path $watchFolder "印刷済み"
        
        # フォルダ内のJPG, PNG, PDFを探す
        $files = Get-ChildItem -Path $watchFolder -File | Where-Object { $_.Extension -match '\.(jpg|png|jpeg|pdf)$' }
        
        foreach ($file in $files) {
            Write-Host ("🔔 新しいファイルを発見しました: " + $file.Name)
            $targetPath = Join-Path $printedFolder $file.Name
            
            try {
                # 1. 印刷済みフォルダへ移動
                Move-Item -Path $file.FullName -Destination $targetPath -ErrorAction Stop
                Write-Host "✅ 「印刷済み」フォルダに移動しました。"
                
                # 2. 印刷処理
                if ($file.Extension -match '\.pdf$') {
                    # PDFの場合：Windows標準の印刷コマンドを使用
                    Write-Host "🖨️ PDFを印刷しています..."
                    Start-Process -FilePath $targetPath -Verb Print -Wait
                } else {
                    # 画像の場合：回転補正をしてからペイントで印刷
                    Write-Host "🔄 画像の向きを確認して補正しています..."
                    $img = [System.Drawing.Image]::FromFile($targetPath)
                    if ($img.Width -gt $img.Height) {
                        $img.RotateFlip([System.Drawing.RotateFlipType]::Rotate90FlipNone)
                        $img.Save($targetPath, [System.Drawing.Imaging.ImageFormat]::Jpeg)
                        Write-Host "🔄 横長だったので縦に回転させました。"
                    }
                    $img.Dispose()
                    
                    Write-Host "🖨️ 画像を印刷しています..."
                    Start-Process mspaint.exe -ArgumentList "/p", "$targetPath" -Wait
                }
                Write-Host "✅ 印刷が完了しました！"
                Write-Host ""
            } catch {
                Write-Warning "❌ 処理中にエラーが発生しました:"
                Write-Host $_.Exception.Message
                Write-Host "⏳ 5秒後に再試行します..."
            }
        }
    }
    # 監視インターバル
    Start-Sleep -Seconds 5
}
