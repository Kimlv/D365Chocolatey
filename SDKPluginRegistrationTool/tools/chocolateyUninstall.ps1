$packageId = "Microsoft.CrmSdk.XrmTooling.PluginRegistrationTool.JL"

Remove-item -Path "$env:ChocolateyInstall\lib\$packageId"

Remove-Item -Path "$([Environment]::GetFolderPath('Desktop'))\Plug-in Registration Tool.lnk"

Remove-Item -Path "$([Environment]::GetFolderPath('ApplicationData'))\D365ChocoTools\Microsoft\$packageId"

$directoryInfo = Get-ChildItem "$([Environment]::GetFolderPath('ApplicationData'))\D365ChocoTools\Microsoft" | Measure-Object
if ($directoryInfo.count -eq 0) {
    Remove-Item -Path "$([Environment]::GetFolderPath('ApplicationData'))\D365ChocoTools\Microsoft"
}