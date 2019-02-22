$packageId = "Microsoft.CrmSdk.XrmTooling.PluginRegistrationTool.JL"

$directory = $PSScriptRoot
$url = Join-Path $directory "..\ToolPackage.zip"
$destination = "$([Environment]::GetFolderPath('ApplicationData'))\D365ChocoTools\Microsoft\$packageId"

Get-ChocolateyUnzip -FileFullPath $url -Destination $destination

# Installs a desktop shortcut to Plugin Registration Tool folder
Install-ChocolateyShortcut -ShortcutFilePath "$([Environment]::GetFolderPath('Desktop'))\Plug-in Registration Tool.lnk" -TargetPath "$destination\tools" -RunAsAdmin