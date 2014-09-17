function Install-AWSPowerShellTool {
 
    [CmdletBinding()]
 
    param (
        [Parameter()]
        [String]
        $Url = "http://sdk-for-net.amazonwebservices.com/latest/AWSToolsAndSDKForNet.msi",
 
        [Parameter()]
        [Switch]
        $UpdateProfile
    )
 
    if (-not ($PSVersionTable.PSVersion -ge [Version]"2.0.0.0")) {
        Throw "PowerShell version must be 2.0 or above"
    }
 
    if (!(New-Object Security.Principal.WindowsPrincipal ([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)) {
        Throw "This function must be run as an administrator"
    }
 
    Write-Verbose "Downloading AWS PowerShell Tools from ${url}"
    Start-BitsTransfer -Source $url -Destination $env:TEMP -Description "AWS PowerShell Tools" -DisplayName "AWS PowerShell Tools"
 
    Write-Verbose "Starting AWS PowerShell Tools install using ${env:Temp}\$(Split-Path -Path $Url -Leaf)"
    $Process = Start-Process -FilePath "msiexec.exe" -ArgumentList "/i ${env:Temp}\$(Split-Path -Path $Url -Leaf) /qf /passive" -Wait -PassThru
 
    if ($Process.ExitCode -ne 0) {
        Throw "Install failed with exit code $($Process.ExitCode)"
    } else {
        if ($UpdateProfile) {
            if (-not (test-Path (Split-Path $PROFILE))) {
                Write-Verbose "Creating WindowsPowerShell folder for copying the profile"
                New-Item -Path (Split-Path $PROFILE) -ItemType Directory -Force | Out-Null
            }
            Write-Verbose "Updating PowerShell Profile at ${PROFILE}"
            Add-Content -Path $PROFILE -Value 'Import-Module -Name "C:\Program Files (x86)\AWS Tools\PowerShell\AWSPowerShell\AWSPowerShell.psd1"' -Force
        }
    }
}
