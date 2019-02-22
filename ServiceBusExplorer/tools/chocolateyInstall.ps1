$packageId = "ServiceBusExplorer.JL"

$directory = $PSScriptRoot
$url = Join-Path $directory "..\ToolPackage.zip"
$destination = "$([Environment]::GetFolderPath('ApplicationData'))\D365ChocoTools\PaoloSalvatori\$packageId"
$exe = Join-Path $destination "tools\ServiceBusExplorer.exe"

Get-ChocolateyUnzip -FileFullPath $url -Destination $destination

# Installs a desktop shortcut to the Service Bus Explorer .exe
Install-ChocolateyShortcut -ShortcutFilePath "$([Environment]::GetFolderPath('Desktop'))\Service Bus Explorer.lnk" -TargetPath $exe -RunAsAdmin