Initialize-Disk -Number 1
Write-Host "Configuring Secondary D Drive.." -ForegroundColor Green
New-Partition -DiskNumber 1 -UseMaximumSize -AssignDriveLetter
Write-Host "Partitioning D Drive.." -ForegroundColor Green
Format-Volume -DriveLetter D -FileSystem NTFS -NewFileSystemLabel Applications -Force -Confirm:$false
Write-Host "Formatting Disk" -ForegroundColor Green
mkdir c:\scripts
Write-Host "Creating scripts folder for remote download on C drive" -ForegroundColor Green