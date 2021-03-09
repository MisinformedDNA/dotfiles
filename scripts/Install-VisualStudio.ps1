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

$products = "Enterprise"
choco upgrade visualstudio2019enterprise
Import-Module (Join-Path $env:ChocolateyInstall extensions\chocolatey-visualstudio\chocolatey-visualstudio.extension.psm1)

$workloads = @(
    "Azure",
    "NetCoreTools",
    "VisualStudioExtension",
    "NetWeb"
) | ForEach-Object {
    Add-VisualStudioWorkload -PackageName $_ -Workload $_ -VisualStudioYear 2019 -ApplicableProducts $products -IncludeRecommendedComponentsByDefault
}

$components = @(
    "Microsoft.VisualStudio.Component.AzureDevOps.OfficeIntegration"
) | ForEach-Object {
    Add-VisualStudioComponent -PackageName $_ -Component $_ -VisualStudioYear 2019 -ApplicableProducts $products
}

$vsixNames = @(
    "MadsKristensen.AddNewFile"
    "MadsKristensen.EditorConfig",
    "MadsKristensen.FileIcons",
    "MadsKristensen.FileNesting",
    "MadsKristensen.ignore",
    "MadsKristensen.SuggestedExtensions",
    "MadsKristensen.Tweaks"
) | ForEach-Object {
    Install-VisualStudioVsixExtensionFromVSMarketplace $_
}
