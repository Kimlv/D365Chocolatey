### Prerequisities ###

# 1. Chocolatey is already installed, if not uncomment the next line
#    Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
# 2. NuGet.org is configured as a package provider, if not uncomment the next 2 lines
#    Install-PackageProvider Nuget -Force -verbose
#    Register-PackageSource -Name nuget.org -Location https://www.nuget.org/api/v2 -ProviderName NuGet
# 3. If committing files in Azure DevOps, under Project Setting -> Repositories -> Project Repo - Project Collection Build Service 
#    needs to have Contribute permission set to Allow
# 4. Azure DevOps build needs to enable: Allow scripts to access the OAuth token
# 5. Update script level variable section below
# 6. Pipeline variables:
#    $(PackagesReadWrite) - Personal Access Token with at least Read permission on Packages
#    $(FeedUrl) - Azure DevOps v2 feed url (v3 doesn't appear to work in Chocolatey GUI) Example: https://{InstanceName}.pkgs.visualstudio.com/_packaging/{FeedName}/nuget/v2


#######################################################################################################
# 1. PowerShell Build Task

### Variables ###

# Name of the package on NuGet.org
$PackageName = "Microsoft.CrmSdk.CoreTools"
# Substitute the working folder and .nuspec file names
$DestinationDirectory = "$(BUILD.SOURCESDIRECTORY)\SDKCoreTools\"
$NuSpecPath = ($DestinationDirectory + "SDKCoreTools.nuspec")


# Check current NuGet version
Write-Host "Checking current version on NuGet..."
$packages = Find-Package -Name $PackageName -ProviderName NuGet -Source "nuget.org"
$NuGetVersion = [Version]$packages[0].Version
Write-Host "NuGet version: "$NuGetVersion

# Check current Chocolatey version
Write-Host "Checking current Chocolatey package version..."
$ChocoVersion = [Version]([xml](Get-Content -Path $NuSpecPath)).package.metadata.version
Write-Host "Chocolatey package version: "$ChocoVersion

# Compare versions
if ($NuGetVersion -le $ChocoVersion) {
    # No update required
    Write-Host "No update required, exiting..."
    "##vso[task.setvariable variable=ContinueUpdate;]$false"
    return
}
"##vso[task.setvariable variable=ContinueUpdate;]$true"

# Download file
Write-Host "Downloading $PackageName $NuGetVersion from NuGet..."
$webClient = New-Object System.Net.WebClient
# .zip file name needs to match name in chocolateyInstall.ps1
$webClient.DownloadFile("https://www.nuget.org/api/v2/package/$PackageName/$NuGetVersion", ($DestinationDirectory + "ToolPackage.zip"))
Write-Host "Download complete"

# Update .nuspec
Write-Host "Updating nuspec version to $NuGetVersion..."
$NuSpec = [xml](Get-Content -Path $NuSpecPath)
$NuSpec.package.metadata.version = [string]$NuGetVersion
$NuSpec.package.metadata.title = "$($packages[0].Metadata.Item('title'))"
#$NuSpec.package.metadata.authors = "$($packages[0].Metadata.Item('Authors'))"
$NuSpec.package.metadata.summary = "$($packages[0].Metadata.Item('summary'))"
$NuSpec.package.metadata.description = "$($packages[0].Metadata.Item('description'))"
$NuSpec.package.metadata.copyright = "$($packages[0].Metadata.Item('copyright'))"
$NuSpec.package.metadata.tags = "$($($packages[0].Metadata.Item('tags')).Replace(',', ''))"
$NuSpec.package.metadata.projectUrl = "$($packages[0].Links.GetEnumerator().Where({$_.Relationship -eq 'project'}).HRef)"
$NuSpec.package.metadata.licenseUrl = "$($packages[0].Links.GetEnumerator().Where({$_.Relationship -eq 'license'}).HRef)"
$NuSpec.Save($NuSpecPath)
Write-Host "Update complete"

"##vso[task.setvariable variable=NewVersion;]$NuGetVersion"

# Pack - assumes Chocolatey is already installed (already installed on Azure DevOps hosted agent)
Write-Host "Creating package..."
CD "$DestinationDirectory"
$command = 'choco pack'
Invoke-Expression $command
Write-Host "Completed package"


#######################################################################################################
# 2. NuGet Build Task - Run Task (custom condition) eq(variables['ContinueUpdate'], 'true')
#    Was not able to get ApiKey authentication working from PowerShell but a NuGet build task works

# push "$(BUILD.SOURCESDIRECTORY)\SDKCoreTools\*.nupkg" -ApiKey "$(PackagesReadWrite)" -Source "$(FeedUrl)"


#######################################################################################################
# 3. PowerShell Build Task - Run Task (custom condition) eq(variables['ContinueUpdate'], 'true')

# Commit update to .nuspec file
#$NuSpecPath = "$(BUILD.SOURCESDIRECTORY)\SDKCoreTools\SDKCoreTools.nuspec"
#
#Write-Host "Committing updated .nuspec..."
#$msg = "Commit from Azure DevOps - update to v$NewVersion"
#git config --global user.email "you@example.com"
#git config --global user.name "Azure DevOps"
#
#CD "$(BUILD.SOURCESDIRECTORY)"
#
#git add $NuSpecPath
#git commit -a -m $msg
#git -c http.extraheader="Authorization: bearer $(System.AccessToken)" push origin HEAD:master
#Write-Host "Commit complete"