Param(
    [ValidateSet('AzureDevOps','Local','AzureVM')]
    [string] $buildEnv = "AzureDevOps",

    [Parameter(Mandatory=$false)]
    [string] $BCContainerHelperPath = $env:BCContainerHelperPath,

    [Parameter(Mandatory=$false)]
    [string] $BCContainerHelperVersion = $env:BCContainerHelperVersion
)

if (-not $BCContainerHelperVersion) { $BCContainerHelperVersion = "latest" }

Write-Host "Version: $BCContainerHelperVersion"

if ($BCContainerHelperPath -ne "" -and (Test-Path $BCContainerHelperPath)) {

    Write-Host "Using BCContainerHelper from $BCContainerHelperPath"
    . $BCContainerHelperPath

}
else {

    $module = Get-InstalledModule -Name BCContainerhelper -ErrorAction SilentlyContinue
    if ($module) {
        $versionStr = $module.Version.ToString()
        Write-Host "BCContainerHelper $VersionStr is installed"
        if ($BCContainerHelperVersion -eq "latest") {
            Write-Host "Determine latest BCContainerHelper version"
            $latestVersion = (Find-Module -Name BCContainerhelper).Version
            $BCContainerHelperVersion = $latestVersion.ToString()
            Write-Host "BCContainerHelper $BCContainerHelperVersion is the latest version"
        }
        if ($BCContainerHelperVersion -ne $module.Version) {
            Write-Host "Updating BCContainerHelper to $BCContainerHelperVersion"
            Update-Module -Name BCContainerhelper -Force -RequiredVersion $BCContainerHelperVersion
            Write-Host "BCContainerHelper updated"
        }
    }
    else {
        if (!(Get-PackageProvider -Name NuGet -ListAvailable -ErrorAction SilentlyContinue)) {
            Write-Host "Installing NuGet Package Provider"
            Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.208 -Force -WarningAction SilentlyContinue | Out-Null
        }
        if ($BCContainerHelperVersion -eq "latest") {
            Write-Host "Installing BCContainerHelper"
            Install-Module -Name BCContainerhelper -Force
        }
        else {
            Write-Host "Installing BCContainerHelper version $BCContainerHelperVersion"
            Install-Module -Name BCContainerhelper -Force -RequiredVersion $BCContainerHelperVersion
        }
        $module = Get-InstalledModule -Name BCContainerhelper -ErrorAction SilentlyContinue
        $versionStr = $module.Version.ToString()
        Write-Host "BCContainerHelper $VersionStr installed"
    }
}
