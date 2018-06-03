<#
    .SYNOPSIS
    Installs the ChocolateyGet package provider/source on this computer.

    .DESCRIPTION
    Installs the ChocolateyGet package provider/source on this computer forcefully.

    .PARAMETER PassThru
    Returns the object returned by "Get-PackageProvider -Name 'ChocolateyGet' -ErrorAction 'SilentlyContinue'".

    .EXAMPLE
    Install-ChocolateyGetProvider

    .EXAMPLE
    Install-ChocolateyGetProvider -PassThru
#>

function Install-ChocolateyGetProvider {
    [CmdletBinding()]
    Param (
        [Switch]
        $PassThru
    )

    if (Get-PackageProvider -Name 'ChocolateyGet' -ErrorAction 'SilentlyContinue') {
        Write-Verbose -Message 'Chocolatey package provider/source already installed.'
        return 'Installed'
    }

    $PackageProviderParams = @{
        Name = 'ChocolateyGet';
        Scope = 'CurrentUser';
        Force = $true;
        ForceBootstrap = $true;
        ErrorAction = 'SilentlyContinue';
    }

    Write-Verbose -Message 'Installing ChocolateyGet PackageProvider.'
    Install-PackageProvider @PackageProviderParams
    $toReturn = Get-PackageProvider -Name 'ChocolateyGet' -ErrorAction 'SilentlyContinue'
    
    if ($toReturn) {
        Write-Verbose -Message 'Chocolatey package provider/source successfully installed.'
    }
    else {
        throw 'ChocolateyGet failed to install'
    }

    if ($PassThru) {
        return $toReturn
    }
}