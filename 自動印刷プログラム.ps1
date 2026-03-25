# ===============================================
# 蜃ｦ譁ｹ縺帙ｓ閾ｪ蜍募魂蛻ｷ繝励Ο繧ｰ繝ｩ繝・育屮隕也畑 蟆丈ｺｺ縺輔ｓ・・# ===============================================

# 庁縲占ｨｭ螳壹題ｦ句ｼｵ繧九ヵ繧ｩ繝ｫ繝縺ｮ蝣ｴ謇・医↓縺｣縺輔＞蠎礼畑縺ｮ蜿嶺ｿ｡繝輔か繝ｫ繝縺ｮ繝代せ縺ｫ譖ｸ縺肴鋤縺医※縺上□縺輔＞・・$watchFolder = "G:\.shortcut-targets-by-id\1XKAv_L2hOGBZXKR7Q2exjpZsUKniPoD3\蜃ｦ譁ｹ縺帙ｓ蜿嶺ｿ｡繝医Ξ繧､縲縺ｫ縺｣縺輔＞"
$printedFolder = Join-Path $watchFolder "蜊ｰ蛻ｷ貂医∩"

# 縲悟魂蛻ｷ貂医∩縲阪ヵ繧ｩ繝ｫ繝縺後↑縺代ｌ縺ｰ菴懈・
if (-not (Test-Path $printedFolder)) {
    New-Item -ItemType Directory -Path $printedFolder | Out-Null
}

Write-Host "==============================================="
Write-Host "  繧ｯ繝ｭ繝ｼ繝舌・隱ｿ蜑､阮ｬ螻縺輔∪蟆ら畑"
Write-Host "  蜃ｦ譁ｹ縺帙ｓ閾ｪ蜍募魂蛻ｷ繝励Ο繧ｰ繝ｩ繝・育屮隕也畑 蟆丈ｺｺ縺輔ｓ・・
Write-Host "==============================================="
Write-Host ""
Write-Host "操 譁ｰ縺励＞蜃ｦ譁ｹ縺帙ｓ縺・Google 繝峨Λ繧､繝・縺ｫ螻翫￥縺ｮ繧定ｦ句ｼｵ縺｣縺ｦ縺・∪縺・.."
Write-Host "窶ｻ縺薙・逕ｻ髱｢繧偵古励阪〒髢峨§繧九→縲∝魂蛻ｷ縺悟●豁｢縺励∪縺吶・
Write-Host ""

# 逶｣隕悶Ν繝ｼ繝・while ($true) {
    # 繝輔か繝ｫ繝蜀・・JPG縺ｨPNG繧呈爾縺・    $files = Get-ChildItem -Path $watchFolder -Include *.jpg, *.png -File
    
    foreach ($file in $files) {
        Write-Host ("粕 譁ｰ縺励＞蜃ｦ譁ｹ縺帙ｓ繧堤匱隕九＠縺ｾ縺励◆: " + $file.Name)
        
        $targetPath = Join-Path $printedFolder $file.Name
        
        try {
            # 蜀咏悄繧偵悟魂蛻ｷ貂医∩縲阪ヵ繧ｩ繝ｫ繝縺ｸ遘ｻ蜍包ｼ育ｧｻ蜍輔〒縺阪↑縺・ｴ蜷医・繝繧ｦ繝ｳ繝ｭ繝ｼ繝我ｸｭ縺ｨ蛻､譁ｭ・・            Move-Item -Path $file.FullName -Destination $targetPath -ErrorAction Stop
            
            Write-Host "蜜・・Windows縺ｮ縲後・繧､繝ｳ繝医阪ｒ菴ｿ縺｣縺ｦ蜊ｰ蛻ｷ繧偵♀鬘倥＞縺励※縺・∪縺・.."
            # 繝壹う繝ｳ繝医ｒ襍ｷ蜍輔＠縺ｦ蜊ｰ蛻ｷ繧貞ｮ溯｡・(/p 繧ｪ繝励す繝ｧ繝ｳ)
            Start-Process mspaint.exe -ArgumentList "/p", "`"$targetPath`"" -Wait
            
            Write-Host "笨・蜊ｰ蛻ｷ縺悟ｮ御ｺ・＠縺ｾ縺励◆・・
            Write-Host ""
        } catch {
            Write-Host "竢ｳ 縺ｾ縺繧､繝ｳ繧ｿ繝ｼ繝阪ャ繝医°繧峨ム繧ｦ繝ｳ繝ｭ繝ｼ繝我ｸｭ縺ｮ縺溘ａ縲∵焚遘貞ｾ・■縺ｾ縺・.."
            Write-Host ""
        }
    }
    
    # 5遘貞ｾ・ｩ・    Start-Sleep -Seconds 5
}
