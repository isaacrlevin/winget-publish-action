Param
(
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
    $Token
)

function Get-Hash {
    param (
        [parameter(Mandatory = $true)]
        [string]
        $Url
    )
    Invoke-WebRequest -Uri $Url -OutFile "./file"
    $hash = Get-Filehash "./file"
    return $hash.Hash
}

function Write-MetaData {
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
    $content = Get-Content "D:\a\_actions\isaacrlevin\winget-publish-action\v.7\templates\$FileName" -Raw
    $content = $content.Replace('<VERSION>', $Version)
    $content = $content.Replace('<USER>', $User)
    $content = $content.Replace('<PACKAGE>', $Package)
    $content = $content.Replace('<HASH>', $Hash)
    $content = $content.Replace('<ARCH>', $Arch)
    $content = $content.Replace('<INSTALLER-TYPE>', $InstallerType)
    $content = $content.Replace('<URL>', $Url)
    $content = $content.Replace('<PUBLISHER>', $Publisher)
    $content = $content.Replace('<PACKAGE-NAME>', $PackageName)
    $content = $content.Replace('<LICENSE>', $License)
    $content = $content.Replace('<DESCRIPTION>', $ShortDescription)

    $fName = $FileName.Replace('user',$User)
    $fName = $FileName.Replace('package',$Package)

    $content | Out-File -Encoding 'UTF8' "./$Version/$fName"
}

New-Item -Path $PWD -Name $Version -ItemType "directory"
$Hash = Get-Hash -Url $Url
Get-ChildItem 'D:\a\_actions\isaacrlevin\winget-publish-action\v.7\templates\*.yaml' | ForEach-Object -Process {
    Write-MetaData -FileName $_.Name -User $User -Package $Package -Url $Url -ShortDescription $ShortDescription -Version $Version -Hash $Hash -Arch $Arch -InstallerType $InstallerType -Publisher $Publisher -PackageName $PackageName -License $License
}
if (-not $Token) {
    return
}

# Install the latest wingetcreate exe
# Need to do things this way, see https://github.com/PowerShell/PowerShell/issues/13138
Import-Module Appx -UseWindowsPowerShell

# Download and install C++ Runtime framework package.
$vcLibsBundleFile = "$env:TEMP\Microsoft.VCLibs.Desktop.appx"
Invoke-WebRequest https://aka.ms/Microsoft.VCLibs.x64.14.00.Desktop.appx -OutFile $vcLibsBundleFile
Add-AppxPackage $vcLibsBundleFile

# Download Winget-Create msixbundle, install, and execute update.
$appxBundleFile = "$env:TEMP\wingetcreate.msixbundle"
Invoke-WebRequest https://aka.ms/wingetcreate/latest/msixbundle -OutFile $appxBundleFile
Add-AppxPackage $appxBundleFile

# Create the PR
wingetcreate submit --token $Token $Version