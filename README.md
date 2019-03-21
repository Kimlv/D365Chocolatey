# D365 Chocolatey

The code contained in this repository allows for creating Chocolatey packages from the Microsoft Dynamics 365 developer tools which are currently available on GitHub. Using Azure DevOps build pipelines, the creation and subsequent updating of these packages can be automated and scheduled. Azure DevOps Artifacts can also serve as a private NuGet feed host for these packages to make distributing them inside your organization easy and kept under your control.  

## Current Packages

[Microsoft.CrmSdk.XrmTooling.PluginRegistrationTool](https://www.nuget.org/packages/Microsoft.CrmSdk.XrmTooling.PluginRegistrationTool)  
[Microsoft.CrmSdk.CoreTools](https://www.nuget.org/packages/Microsoft.CrmSdk.CoreTools)  
[Microsoft.CrmSdk.XrmTooling.PackageDeployment.Wpf](https://www.nuget.org/packages/Microsoft.CrmSdk.XrmTooling.PackageDeployment.Wpf)  
[Microsoft.CrmSdk.XrmTooling.ConfigurationMigration.Wpf](https://www.nuget.org/packages/Microsoft.CrmSdk.XrmTooling.ConfigurationMigration.Wpf)  
[Service Bus Explorer](https://github.com/paolosalvatori/ServiceBusExplorer)

## About Chocolatey

[Chocolatey](https://chocolatey.org) (from their website) is a package manager for Windows (like apt-get or yum but for Windows). It was designed to be a decentralized framework for quickly installing applications and tools that you need. It is built on the NuGet infrastructure currently using PowerShell as its focus for delivering packages from the distros to your door, err computer.

Chocolatey is a single, unified interface designed to easily work with all aspects of managing Windows software (installers, zip archives, runtime binaries, internal and 3rd party software) using a packaging framework that understands both versioning and dependency requirements. Chocolatey packages encapsulate everything required to manage a particular piece of software into one deployment artifact by wrapping installers, executables, zips, and scripts into a compiled package file. Chocolatey packages can be used independently, but also integrate with configuration managers like SCCM, Puppet, and Chef. Chocolatey is trusted by businesses all over the world to manage their software deployments on Windows. You’ve never had so much fun managing software!

[Installing Chocolatey](https://chocolatey.org/install)  
[Installing Chocolatey GUI](https://chocolatey.org/packages/ChocolateyGUI)  
[Other Available Packages](https://chocolatey.org/packages)  

## Instructions For Creating Packages

Using Microsoft.CrmSdk.XrmTooling.PluginRegistrationTool as an example.

1. Copy the SDKPluginRegistrationTool folder to the same level in the project hierarchy and rename for the new package
2. Rename files for the new package
3. Update the .nuspec file with information regarding the package you are creating
4. Update the .ps1 file and replace Variables in #1 & path names in #2 and #3
5. Update the .ps1 file based on the type of application being packaged, see the [Chocolatey Docs](https://chocolatey.org/docs#packages) for more info
6. Update README.md
7. Update chocolateyInstall.ps1 and perform operations to install the application
8. Update chocolateyUninstall.ps1 and perform operations to uninstall the application - reverse whatever was done if possible
9. Check into Azure DevOps git repository
10. Create a Build Pipeline
    1. Source equals this repository
    2. Agent set Allow scripts to access the OAuth token to checked
    3. Add PowerShell (2.*) task with code from #1
    4. Add NuGet (2.*) task Command equal to custom and the code from #2
        1. Run this task equals Custom donditions
        2. Custom condition equals **eq(variables['ContinueUpdate'], 'true')**
    5. Add PowerShell (2.*) task with code from #3
        1. Run this task equals Custom donditions
        2. Custom condition equals **eq(variables['ContinueUpdate'], 'true')**
    6. Ensure Project Collection Build Service has Contribute permission set to Allow on this repository
    7. (Optionally) Under Triggers, schedule build to run so it automatically check for updates if applicable
