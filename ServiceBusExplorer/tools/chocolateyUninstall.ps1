$packageId = "ServiceBusExplorer.JL"

Remove-item -Path "$env:ChocolateyInstall\lib\$packageId" -Recurse

Remove-Item -Path "$([Environment]::GetFolderPath('Desktop'))\Service Bus Explorer.lnk"

Remove-Item -Path "$([Environment]::GetFolderPath('ApplicationData'))\D365ChocoTools\PaoloSalvatori\$packageId" -Recurse

$directoryInfo = Get-ChildItem "$([Environment]::GetFolderPath('ApplicationData'))\D365ChocoTools\PaoloSalvatori" | Measure-Object
if ($directoryInfo.count -eq 0) {
    Remove-Item -Path "$([Environment]::GetFolderPath('ApplicationData'))\D365ChocoTools\PaoloSalvatori"
}
