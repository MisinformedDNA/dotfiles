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

$visualStudioProducts = "Enterprise"
choco upgrade visualstudio2019enterprise
Import-Module (Join-Path $env:ChocolateyInstall extensions\chocolatey-visualstudio\chocolatey-visualstudio.extension.psm1)

$workloads = @(
    "Azure",
    "NetCoreTools",
    "VisualStudioExtension",
    "NetWeb"
)
foreach ($workload in $workloads) {
    Add-VisualStudioWorkload -PackageName $workload -Workload $workload -VisualStudioYear 2019 -ApplicableProducts "Enterprise" -IncludeRecommendedComponentsByDefault
}

$vsixNames = @(
    "MadsKristensen.AddNewFile"
    "MadsKristensen.EditorConfig",
    "MadsKristensen.FileIcons",
    "MadsKristensen.FileNesting",
    "MadsKristensen.ignore",
    "MadsKristensen.SuggestedExtensions",
    "MadsKristensen.Tweaks",
)

foreach ($vsixName in $vsixNames) {
    Install-VisualStudioVsixExtensionFromVSMarketplace $vsixName
}
