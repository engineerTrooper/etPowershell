$etConfig=Get-Content -Path config.json | ConvertFrom-Json
$etSettings=Get-Content -Path settings.json | ConvertFrom-Json

Write-Host "Checking for elevated permissions..."
if (!([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
  Write-Warning "Insufficient permissions. This PowerShell doesn't run as Administrator! Some Function will not deliver results while systemCheck.ps1 is running. Open the PowerShell console as an administrator and run this script again."

  Write-Host("If you want to continue press [ENTER], if not type 'exit'")
  $stopScript = Read-Host
  if($stopScript)   #checks if variable null or empty, if not scripts exit here
  {
    Write-Host("---Stop script here (Exit)---")
    exit
  }
}
else {
  Write-Host "Code is running as administrator — go on executing the script..." -ForegroundColor Green
}


Write-Host "`n################################################"
Write-Host "file: systemCheck.ps1"
$date = Get-Date
Write-Host ("start at: {0}" -f $date)
Write-Host "################################################`n"


Write-Host("Input directory path or press [ENTER] to use etSettings.defaultSavePath")
$savePath = Read-Host
if(!$savePath)
{
  Write-Host("No path was given")
  Write-Host("using etSettings.defaultSavePath instead")
  if((Test-Path -Path $etSettings.defaultSavePath))
  {
    $savePath = $etSettings.defaultSavePath
  }
  else
  {
    Write-Host("Err: Path doesn't exist {0}" -f $etSettings.defaultSavePath)
    Write-Host("---Stop script here (Exit)---")
    exit
  }
}
elseif(!(Test-Path -Path $savePath))
{
  Write-Host("Err: Path doesn't exist {0}" -f $savePath)
  Write-Host("---Stop script here (Exit)---")
  exit
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

Write-Host " Get InstalledSoftware avaliable over winget"
$currPath = Join-Path -path $savePath -childpath "\InstalledSoftware-winget.txt"
winget list |
  Sort-Object |
    Out-File winget-packages-installed.txt

Write-Host " powercfg get energyreport {`n"
$currPath = Join-Path -path $savePath -childpath "\Powercfg-Energyreport.html"
powercfg.exe -energy -output $currPath
#powercfg.exe -energy -output $currPath -verb runAs
Write-Host "`n}`n"


Write-Host " powercfg get batteryreport {`n"
$currPath = Join-Path -path $savePath -childpath "\Powercfg-Batteryreport.html"
powercfg.exe -batteryreport -output $currPath
Write-Host "`n}`n"


Write-Host " Get-PSDrive -PSProvider 'FileSystem'"
$currPath = Join-Path -path $savePath -childpath "\PSProvider-FileSystem.txt"
Get-PSDrive -PSProvider 'FileSystem' |
  Out-File $currPath


  Write-Host " Collecting Information about Volumes (Harddrives, SSDs, ...)"
  $currPath = Join-Path -path $savePath -childpath "\Volumes-Information.txt"
  Get-PhysicalDisk |
    Out-File $currPath
  Get-Disk |
    Out-File $currPath -Append
  Get-Partition |
    Out-File $currPath -Append
  Get-Volume |
    Out-File $currPath -Append


Write-Host ("`n`n finished.`n See results at {0}" -f $savePath)

