# ===============================================
# 蜃ｦ譁ｹ縺帙ｓ閾ｪ蜍募魂蛻ｷ繝励Ο繧ｰ繝ｩ繝・域悽蠎嶺ｻ墓ｧ假ｼ壼ｮ悟・閾ｪ蜍輔・PDF繝ｻ蝗櫁ｻ｢蟇ｾ蠢懶ｼ・# ===============================================
Add-Type -AssemblyName System.Drawing

# 庁縲占ｨｭ螳壹台ｽｿ逕ｨ縺吶ｋ繝励Μ繝ｳ繧ｿ繝ｼ蜷搾ｼ亥ｺ苓・縺ｮ迺ｰ蠅・↓蜷医ｏ縺帙※險ｭ螳壽ｸ医∩・・$printerName = "TASKalfa 408ci(J)"

# 庁縲占ｨｭ螳壹題ｦ句ｼｵ繧九ヵ繧ｩ繝ｫ繝縺ｮ繝ｪ繧ｹ繝・$watchFolders = @(
    "G:\.shortcut-targets-by-id\1XKAv_L2hOGBZXKR7Q2exjpZsUKniPoD3\蜃ｦ譁ｹ縺帙ｓ蜿嶺ｿ｡繝医Ξ繧､縲縺ｫ縺｣縺輔＞",
    "G:\.shortcut-targets-by-id\1AWpZQwtF2VusSpJf9PF3OnurIdrHI6uj\Google繝輔か繝ｼ繝縲縺ｫ縺｣縺輔＞蠎・
)

# 蜷・ヵ繧ｩ繝ｫ繝縺ｮ縲悟魂蛻ｷ貂医∩縲肴ｺ門ｙ
foreach ($folder in $watchFolders) {
    if (-not (Test-Path (Join-Path $folder "蜊ｰ蛻ｷ貂医∩"))) { New-Item -ItemType Directory -Path (Join-Path $folder "蜊ｰ蛻ｷ貂医∩") | Out-Null }
}

Write-Host "==============================================="
Write-Host "  繧ｯ繝ｭ繝ｼ繝舌・隱ｿ蜑､阮ｬ螻縺輔∪蟆ら畑"
Write-Host "  閾ｪ蜍募魂蛻ｷ繝励Ο繧ｰ繝ｩ繝 遞ｼ蜒堺ｸｭ...・亥ｮ悟・閾ｪ蜍包ｼ解沚ｵ"
Write-Host "==============================================="
Write-Host ""
Write-Host "操 譁ｰ縺励＞繝輔ぃ繧､繝ｫ縺・Google 繝峨Λ繧､繝・縺ｫ螻翫￥縺ｮ繧定ｦ句ｼｵ縺｣縺ｦ縺・∪縺・.."

while ($true) {
    foreach ($watchFolder in $watchFolders) {
        $printedFolder = Join-Path $watchFolder "蜊ｰ蛻ｷ貂医∩"
        
        # 繝輔か繝ｫ繝蜀・・JPG, PNG, PDF繧呈爾縺・        $files = Get-ChildItem -Path $watchFolder -File | Where-Object { $_.Extension -match '\.(jpg|png|jpeg|pdf)$' }
        
        foreach ($file in $files) {
            Write-Host ("粕 繝輔ぃ繧､繝ｫ繧堤匱隕九＠縺ｾ縺励◆: " + $file.Name)
            $target = Join-Path $printedFolder $file.Name
            
            try {
                # 1. 蜊ｰ蛻ｷ貂医∩繝輔か繝ｫ繝縺ｸ遘ｻ蜍・                Move-Item -Path $file.FullName -Destination $target -ErrorAction Stop
                Write-Host "笨・縲悟魂蛻ｷ貂医∩縲阪ヵ繧ｩ繝ｫ繝縺ｫ遘ｻ蜍輔＠縺ｾ縺励◆縲・
                
                # 2. 蜊ｰ蛻ｷ蜃ｦ逅・                if ($file.Extension -match '\.pdf$') {
                    # PDF縺ｮ蝣ｴ蜷茨ｼ啗indows讓呎ｺ悶・蜊ｰ蛻ｷ繧ｳ繝槭Φ繝峨ｒ菴ｿ逕ｨ
                    Write-Host "蜜・・PDF繧貞魂蛻ｷ縺励※縺・∪縺・.."
                    Start-Process -FilePath $target -Verb Print -Wait
                } else {
                    # 逕ｻ蜒上・蝣ｴ蜷茨ｼ壼屓霆｢陬懈ｭ｣
                    Write-Host "売 逕ｻ蜒上・蜷代″繧定｣懈ｭ｣縺励※縺・∪縺・.."
                    $img = [System.Drawing.Image]::FromFile($target)
                    if ($img.Width -gt $img.Height) {
                        # 讓ｪ髟ｷ縺ｪ繧・0蠎ｦ蝗櫁ｻ｢縺輔○縺ｦ邵ｦ縺ｫ縺吶ｋ
                        $img.RotateFlip([System.Drawing.RotateFlipType]::Rotate90FlipNone)
                        $img.Save($target, $img.RawFormat) # 蜈・・蠖｢蠑上〒菫晏ｭ・                        Write-Host "売 讓ｪ髟ｷ縺縺｣縺溘・縺ｧ邵ｦ縺ｫ蝗櫁ｻ｢縺輔○縺ｾ縺励◆縲・
                    }
                    $img.Dispose()
                    
                    # 蜊ｰ蛻ｷ・嗷undll32 繧剃ｽｿ縺｣縺ｦ逕ｻ髱｢繧貞・縺輔★縺ｫ繝励Μ繝ｳ繧ｿ繝ｼ縺ｫ逶ｴ騾・                    Write-Host "蜜・・逕ｻ蜒上ｒ閾ｪ蜍募魂蛻ｷ縺励※縺・∪縺・.."
                    $arg = "C:\Windows\System32\shimgvw.dll,ImageView_PrintTo `"$target`" `"$printerName`""
                    Start-Process "rundll32.exe" -ArgumentList $arg -Wait
                }
                Write-Host "笨・蜊ｰ蛻ｷ螳御ｺ・ｼ・
                Write-Host ""
            } catch {
                Write-Warning "笶・蜃ｦ逅・ｸｭ縺ｫ繧ｨ繝ｩ繝ｼ縺檎匱逕溘＠縺ｾ縺励◆:"
                Write-Host $_.Exception.Message
                Write-Host "竢ｳ 5遘貞ｾ後↓蜀崎ｩｦ陦後＠縺ｾ縺・.."
            }
        }
    }
    # 5遘貞ｾ・ｩ・    Start-Sleep -Seconds 5
}
