# ===============================================
# 処方せん自動印刷プログラム（監視用 小人さん）
# ===============================================

# 💡【設定】見張るフォルダの場所（にっさい店用の受信フォルダのパスを設定済み）
# 💡【設定】見張るフォルダのリスト（にっさい店用）
$watchFolders = @(
    "G:\.shortcut-targets-by-id\1XKAv_L2hOGBZXKR7Q2exjpZsUKniPoD3\処方せん受信トレイ　にっさい",
    "G:\.shortcut-targets-by-id\1AWpZQwtF2VusSpJf9PF3OnurIdrHI6uj\アンケートにっさい"
)

foreach ($folder in $watchFolders) {
    $printedFolder = Join-Path $folder "印刷済み"
    if (-not (Test-Path $printedFolder)) { New-Item -ItemType Directory -Path $printedFolder | Out-Null }
}

Write-Host "==============================================="
Write-Host "  クローバー調剤薬局さま専用"
Write-Host "  処方せん自動印刷プログラム（監視用 小人さん）"
Write-Host "==============================================="
Write-Host ""
Write-Host "👀 新しい処方せんが Google ドライブ に届くのを見張っています..."
Write-Host "※この画面を「×」で閉じると、印刷が停止します。"
Write-Host ""

# 監視ループ
while ($true) {
    foreach ($watchFolder in $watchFolders) {
        $printedFolder = Join-Path $watchFolder "印刷済み"
        
        # フォルダ内のJPG, PNG, PDFを探す
        $files = Get-ChildItem -Path $watchFolder -File | Where-Object { $_.Extension -match '\.(jpg|png|jpeg|pdf)$' }
        
        foreach ($file in $files) {
        Write-Host ("🔔 新しい処方せんを発見しました: " + $file.Name)
        
        $targetPath = Join-Path $printedFolder $file.Name
        
        try {
            # 写真を「印刷済み」フォルダへ移動（移動できない場合はダウンロード中と判断）
            Move-Item -Path $file.FullName -Destination $targetPath -ErrorAction Stop
            
            Write-Host "🖨️ Windowsの「ペイント」を使って印刷をお願いしています..."
            # ペイントを起動して印刷を実行 (/p オプション)
            Start-Process mspaint.exe -ArgumentList "/p", ""$targetPath"" -Wait
            
            Write-Host "✅ 印刷が完了しました！"
            Write-Host ""
        } catch {
            Write-Host "⏳ まだインターネットからダウンロード中のため、数秒待ちます..."
            Write-Host ""
        }
    }
    
    # 5秒待機
    Start-Sleep -Seconds 5
}
