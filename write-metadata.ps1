param (
    [parameter(Mandatory = $true)]
    [string]
    $FileName,
    [parameter(Mandatory = $true)]
    [string]
    $User,
    [parameter(Mandatory = $true)]
    [string]
    $Package,
    [parameter(Mandatory = $true)]
    [string]
    $Version,
    [parameter(Mandatory = $true)]
    [string]
    $Url,
    [parameter(Mandatory = $true)]
    [string]
    $Arch,
    [parameter(Mandatory = $true)]
    [string]
    $InstallerType,
    [parameter(Mandatory = $true)]
    [string]
    $Publisher,
    [parameter(Mandatory = $true)]
    [string]
    $PackageName,
    [parameter(Mandatory = $true)]
    [string]
    $License,
    [parameter(Mandatory = $true)]
    [string]
    $ShortDescription,
    [parameter(Mandatory = $true)]
    [string]
    $Hash
)
$content = Get-Content $FileName -Raw
$content = $content.Replace('<VERSION>', $Version)
$content = $content.Replace('<PACKAGE>', $Package)
$content = $content.Replace('<HASH>', $Hash)
$content = $content.Replace('<ARCH>', $Arch)
$content = $content.Replace('<INSTALLER-TYPE>', $InstallerType)
$content = $content.Replace('<URL>', $Url)
$content = $content.Replace('<PUBLISHER>', $Publisher)
$content = $content.Replace('<PACKAGE-NAME>', $PackageName)
$content = $content.Replace('<LICENSE>', $License)
$content = $content.Replace('<DESCRIPTION>', $ShortDescription)
$content | Out-File -Encoding 'UTF8' "./$Version/$FileName"