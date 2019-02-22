$packageId = "Microsoft.CrmSdk.XrmTooling.PackageDeployment.Wpf.JL"

$directory = $PSScriptRoot
$url = Join-Path $directory "..\ToolPackage.zip"
$destination = "$([Environment]::GetFolderPath('ApplicationData'))\D365ChocoTools\Microsoft\$packageId"

Get-ChocolateyUnzip -FileFullPath $url -Destination $destination

# Installs a desktop shortcut to Package Deployer folder
Install-ChocolateyShortcut -ShortcutFilePath "$([Environment]::GetFolderPath('Desktop'))\SDK Package Deployer.lnk" -TargetPath "$destination\tools" -RunAsAdmin