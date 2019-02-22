$packageId = "Microsoft.CrmSdk.XrmTooling.PackageDeployment.Wpf.JL"

Remove-item -Path "$env:ChocolateyInstall\lib\$packageId"

Remove-Item -Path "$([Environment]::GetFolderPath('Desktop'))\SDK Package Deployer.lnk"

Remove-Item -Path "$([Environment]::GetFolderPath('ApplicationData'))\D365ChocoTools\Microsoft\$packageId"

$directoryInfo = Get-ChildItem "$([Environment]::GetFolderPath('ApplicationData'))\D365ChocoTools\Microsoft" | Measure-Object
if ($directoryInfo.count -eq 0) {
    Remove-Item -Path "$([Environment]::GetFolderPath('ApplicationData'))\D365ChocoTools\Microsoft"
}