function Install-VisualStudioVsixExtensionFromVSMarketplace($itemName) {
    $packageUrl = Get-VisualStudioMarketplaceDownloadUrl($itemName)

    Install-VisualStudioVsixExtension -Name $itemName -Url $packageUrl
}

function Get-VisualStudioMarketplaceDownloadUrl($itemName) {
    $marketplaceUrl = "https://marketplace.visualstudio.com/"
    $itemUrl = "$($marketplaceUrl)items?itemName=$itemName"
    $response = Invoke-WebRequest $itemUrl -UseBasicParsing
    $href = ($response.Links | Where-Object { $_.class -eq "install-button-container" }).href

    return "$marketplaceUrl$href"
}

function ShouldInstallVsixes {
    $path = Join-Path $env:LOCALAPPDATA "PersonalSettings"
    New-Item $path -ItemType Directory -ErrorAction SilentlyContinue

    $filePath = Join-Path $path "vsixinstallation.txt"
    return (-not (Test-Path $filePath))
}

function MarkInstalledVsixes {
    $path = Join-Path $env:LOCALAPPDATA "PersonalSettings"
    $filePath = Join-Path $path "vsixinstallation.txt"
    Set-Content -Path $filePath -Value (Get-Date)
}

$products = "Enterprise"
choco upgrade visualstudio2019enterprise
Import-Module (Join-Path $env:ChocolateyInstall extensions\chocolatey-visualstudio\chocolatey-visualstudio.extension.psm1)

@(
    "Azure",
    "NetCoreTools",
    "VisualStudioExtension",
    "NetWeb"
) | ForEach-Object {
    Add-VisualStudioWorkload -PackageName $_ -Workload $_ -VisualStudioYear 2019 -ApplicableProducts $products -IncludeRecommendedComponentsByDefault
}

@(
    "Microsoft.VisualStudio.Component.AzureDevOps.OfficeIntegration"
) | ForEach-Object {
    Add-VisualStudioComponent -PackageName $_ -Component $_ -VisualStudioYear 2019 -ApplicableProducts $products
}


if (ShouldInstallVsixes) {
    @(
        "MadsKristensen.AddNewFile"
        "MadsKristensen.EditorConfig",
        "MadsKristensen.FileIcons",
        "MadsKristensen.FileNesting",
        "MadsKristensen.ignore",
        "MadsKristensen.Tweaks"
    ) | ForEach-Object {
        Install-VisualStudioVsixExtensionFromVSMarketplace $_ -ErrorAction Ignore
    }

    MarkInstalledVsixes
}