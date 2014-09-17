class iis-UrlRewrite {
  $exe_name = "iis-UrlRewrite.ps1"
  $location = "puppet:///modules/${module_name}/${exe_name}"
  $psdisk = 'C:\scripts\iis-UrlRewrite.ps1'
#######
  $msiname = "rewrite_2.0_rtw_x64.msi"
  $msifile = "puppet:///modules/${module_name}/${msiname}"
  $msidisk = 'c:\scripts\rewrite_2.0_rtw_x64.msi' 
 # Upload powershell script
  file { $psdisk:
    ensure => file,
    source => $location,
    mode   => '1777',
    owner => 'administrator',
    group  => 'administrators',
 } 

#Upload exe or msi to server
  file { $msidisk:
    ensure => file,
    source => $msifile,
    mode   => '1777',
    owner => 'administrator',
    group  => 'administrators',
  }

# Install IIS URL rewrite 2.0 using the powershell command  
  exec { $psdisk:
    require =>  Class [puppet-iis],
  	command => 'c:\\windows\syswow64\windowspowershell\v1.0\powershell.exe  -executionpolicy remotesigned -file C:\scripts\iis-UrlRewrite.ps1',
    }
}
