$etConfig = Get-Content -Path config.json | ConvertFrom-Json

Write-Host("       _   ____                        ____  _          _ _   ") -ForegroundColor Green
Write-Host("   ___| |_|  _ \ _____      _____ _ __/ ___|| |__   ___| | |  ") -ForegroundColor Green
Write-Host("  / _ \ __| |_) / _ \ \ /\ / / _ \ '__\___ \| '_ \ / _ \ | |  ") -ForegroundColor Green
Write-Host(" |  __/ |_|  __/ (_) \ V  V /  __/ |   ___) | | | |  __/ | |  ") -ForegroundColor Green
Write-Host("  \___|\__|_|   \___/ \_/\_/ \___|_|  |____/|_| |_|\___|_|_|  ") -ForegroundColor Green
Write-Host("##############################################################")
                                                         
Write-Host("Version:       {0}" -f $etConfig.info.version)
Write-Host("Release Date:  {0}" -f $etConfig.info.releaseDate)
Write-Host("Origin Source: {0}" -f $etConfig.info.originSource)
Write-Host("License:       {0}" -f $etConfig.info.license)
Write-Host("License File:  {0}" -f $etConfig.info.licenseFile)

Write-Host("{0}" -f $etConfig.help.fullDocumentation)