$packageId = "Microsoft.CrmSdk.CoreTools.JL"

$directory = $PSScriptRoot
$url = Join-Path $directory "..\ToolPackage.zip"
$destination = "$([Environment]::GetFolderPath('ApplicationData'))\D365ChocoTools\Microsoft\$packageId"

Get-ChocolateyUnzip -FileFullPath $url -Destination $destination

# Installs a desktop shortcut to the Core Tools folder
Install-ChocolateyShortcut -ShortcutFilePath "$([Environment]::GetFolderPath('Desktop'))\SDK Core Tools.lnk" -TargetPath "$destination\content\bin\coretools" -RunAsAdmin