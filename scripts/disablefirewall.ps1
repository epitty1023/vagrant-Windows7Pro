#Disable Windows Firewall
&netsh "advfirewall" "set" "allprofiles" "state" "off"
Write-Host "Windows Firewall has been disabled.....  moving on!" -ForegroundColor Green