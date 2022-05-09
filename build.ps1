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
    $content = Get-Content "D:\a\_actions\isaacrlevin\winget-publish-action\v.5\templates\$FileName" -Raw
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
Get-ChildItem 'D:\a\_actions\isaacrlevin\winget-publish-action\v.5\templates\*.yaml' | ForEach-Object -Process {
    Write-MetaData -FileName $_.Name -User $User -Package $Package -Url $Url -ShortDescription $ShortDescription -Version $Version -Hash $Hash -Arch $Arch -InstallerType $InstallerType -Publisher $Publisher -PackageName $PackageName -License $License
}
if (-not $Token) {
    return
}
# Get the latest wingetcreate exe
Invoke-WebRequest 'https://aka.ms/wingetcreate/latest/self-contained' -OutFile wingetcreate.exe
# Create the PR
./wingetcreate.exe submit --token $Token $Version