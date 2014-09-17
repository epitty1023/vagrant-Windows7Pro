# Install Puppet
$MsiUrl = "https://s3.amazonaws.com/GCC_vagrant/puppet-enterprise-3.3.1.msi"
 
$PuppetInstalled = $false
try {
  $ErrorActionPreference = "Stop";
  Get-Command puppet | Out-Null
  $PuppetInstalled = $true
  $PuppetVersion=&puppet "--version"
  Write-Host "Puppet $PuppetVersion is installed. This process does not ensure the exact version or at least version specified, but only that puppet is installed. Exiting..."
  Exit 0
} catch {
  Write-Host "Puppet Enterprise is not installed, I will install it for you......."
}
 
if (!($PuppetInstalled)) {
  $currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
  if (! ($currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))) {
    Write-Host -ForegroundColor Red "You must run this script as an administrator."
    Exit 1
  }
 
  # Install it - msiexec will download from the url
  $install_args = @("/qn", "/norestart","/i", $MsiUrl)
  Write-Host "Installing Puppet. Running msiexec.exe $install_args"
  $process = Start-Process -FilePath msiexec.exe -ArgumentList $install_args -Wait -PassThru
  if ($process.ExitCode -ne 0) {
    Write-Host "Installer failed."
    Exit 1
  }
 
  # Stop the service that it autostarts
  Write-Host "Stopping Puppet service that is running by default..."
  Start-Sleep -s 5
  Stop-Service -Name puppet
 
  Write-Host "Puppet Enterprise was successfully installed."
}