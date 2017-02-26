[CmdletBinding()]
param(
    [string] $ClassName = 'Win32Error',
    [string] $Namespace = 'BetterWin32Errors',
    [string] $SdkIncludeDir # Download the Windows SDK from: https://developer.microsoft.com/en-us/windows/downloads/windows-10-sdk
)

$ErrorActionPreference = 'Stop'

function Main {
    Add-Type -AssemblyName System.Web
    
    Write-Output @"
namespace $Namespace
{
    /// <summary>
    /// Constants defined in winerror.h.
    /// </summary>
    public enum $ClassName : uint
    {
"@

    Get-Win32Errors |
        ForEach-Object {
            if ($_.Summary) {
                Write-Output "        /// <summary>$([System.Web.HttpUtility]::HtmlEncode($_.Summary))</summary>"
            }
            Write-Output "        $($_.Name)$($_.Spaces)= $($_.Value),$($_.Rest)"
        } |
        Write-Output

Write-Output @"
    }
}
"@
}

class Win32Error {
    [string] $Summary
    [string] $Name
    [string] $Spaces
    [string] $Value
    [string] $Rest
}

function Get-Win32Errors {
    [OutputType([Win32Error])]
    param()

    Get-Content (Get-WinErrorPath) |
        Get-GroupsBetweenInclusive { $_ -match '^// MessageText:$' } { $_ -match '^#define' } |
        ForEach-Object {
            $summaries = $_.Items[0..($_.Items.length-2)] |
                ForEach-Object { $_ -replace '^//( |$)','' } |
                Where-Object { $_ -and $_ -ne 'MessageText:' }

            $_.Items[-1] -match '^#define (?<name>\S+)(?<spaces>\s+)(?<value>\S+)(?<rest>.*)' | Out-Null
            $value = $Matches['value'] -replace '^(?:_HRESULT_TYPEDEF_|_NDIS_ERROR_TYPEDEF_)\(([^)]+)\)','$1'
            if ($value) {
                $value = $value.TrimEnd('L')
            }

            New-Object -TypeName Win32Error -Property @{
                Summary = $summaries
                Name = $Matches['name']
                Spaces = $Matches['spaces']
                Value = $value
                Rest = $Matches['rest']
            }
        } |
        Get-UniqueWithExpression { $_.Name }        
}

function Get-WinErrorPath {
    $dir = $script:SdkIncludeDir
    if (-not $dir) {
        $includeDir = "${Env:ProgramFiles(x86)}\Windows Kits\10\Include"
        $version = Get-ChildItem -Directory $includeDir |
            Select-Object -ExpandProperty Name |
            Sort-Object -Descending |
            Select-Object -First 1
        $dir = Join-Path $includeDir $version
    }

    if (Test-Path $dir) {
        Join-Path $dir 'shared\winerror.h'
    }
}

function Get-GroupsBetweenInclusive {
    param(
        [scriptblock] $Start,
        [scriptblock] $End
    )

    begin {
        $inBlock = $false
        $group = $null
    }

    process {
        if ($group) {
            $group.Items += $_
            if ($_ | & $End) {
                Write-Output $group
                $group = $null
            }
        }
        else {
            if ($_ | & $Start ) {
                $group = New-Object -TypeName psobject -Property @{
                    Items = @($_)
                }
            }
        }
    }
}

function Get-UniqueWithExpression {
    param(
        [Parameter(Mandatory = $true)]
        [scriptblock] $KeyExpression,

        [Parameter(ValueFromPipeline = $true)]
        $Input
    )
    begin {
        $seenKeys = @{}
    }
    process {
        $key = $Input | & $KeyExpression
        if (-not $seenKeys.ContainsKey($key)) {
            $seenKeys[$key] = $true
            Write-Output $Input
        }
    }
}

Main
