Write-Host "`n################################################"
Write-Host "file: systemCheck.ps1"
$date = Get-Date
Write-Host ("start at: {0}" -f $date)
Write-Host "################################################`n"

$savePath = ""
While (!(Test-Path -Path $savePath))
{
    # if($savePath -eq "exit"){break}
    $savePath = Read-Host -Prompt "Input directory path"
    if((Test-Path -Path $savePath))
    {
        break
    }
    else
    {
        Write-Host "Err: Path doesn't exist $savePath"
    }
}

Write-Host "`n`nCheck..."

Write-Host " ExecutionPolicy"
$currPath = Join-Path -path $savePath -childpath "ExecutionPolicy.txt"
Get-ExecutionPolicy |
  Out-File $currPath


Write-Host " ComputerInfo"
$currPath = Join-Path -path $savePath -childpath "\ComputerInfo.txt"
Get-ComputerInfo |
  Out-File $currPath


Write-Host " Get-Command"
$currPath = Join-Path -path $savePath -childpath "\Get-Command.txt"
Get-Command |
  Out-File $currPath


Write-Host " Get InstalledSoftware"
$currPath = Join-Path -path $savePath -childpath "\InstalledSoftware.txt"
$pathsToInstalledSoftware=@(
  'HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\',
  'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\'
)
Out-File $currPath        # removes old file and add new empty one
foreach($path in $pathsToInstalledSoftware){
  Get-ChildItem -Path $path | 
    Get-ItemProperty | 
      Select-Object DisplayName, Publisher, InstallDate, DisplayVersion, InstallLocation |
        Format-Table -AutoSize |  
          Out-File $currPath -Append
}


Write-Host " powercfg get energyreport {`n"
$currPath = Join-Path -path $savePath -childpath "\Powercfg-Energyreport.html"
powercfg.exe -energy -output $currPath
Write-Host "`n}`n"


Write-Host " powercfg get batteryreport {`n"
$currPath = Join-Path -path $savePath -childpath "\Powercfg-Batteryreport.html"
powercfg.exe -batteryreport -output $currPath
Write-Host "`n}`n"



Write-Host ("`n`n finished.`n See results at {0}" -f $savePath)