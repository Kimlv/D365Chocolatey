$packageId = "Microsoft.CrmSdk.CoreTools.JL"

Remove-item -Path "$env:ChocolateyInstall\lib\$packageId"

Remove-Item -Path "$([Environment]::GetFolderPath('Desktop'))\SDK Core Tools.lnk"

Remove-Item -Path "$([Environment]::GetFolderPath('ApplicationData'))\D365ChocoTools\Microsoft\$packageId"

$directoryInfo = Get-ChildItem "$([Environment]::GetFolderPath('ApplicationData'))\D365ChocoTools\Microsoft" | Measure-Object
if ($directoryInfo.count -eq 0) {
    Remove-Item -Path "$([Environment]::GetFolderPath('ApplicationData'))\D365ChocoTools\Microsoft"
}