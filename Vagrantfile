# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
config.vm.box = "windows7"
  config.vm.box_url = "https://vagrantcloud.com/ezequielpitty/boxes/Windows7Pro/versions/1/providers/virtualbox.box"
  config.vm.guest = :windows7
 
   # Configure 2GB (2048MB) of memory
   file_to_disk = './tmp/large_disk.vdi'
  config.vm.provider :virtualbox do |vb|
    vb.gui = true
    vb.customize ["modifyvm", :id, "--memory", 2048]
    vb.customize ["modifyvm", :id, "--cpus", "2"]
    vb.customize ['createhd', '--filename', file_to_disk, '--size', 60 * 1024]
    vb.customize ['storageattach', :id, '--storagectl', 'IDE Controller', '--port', 1, '--device', 0, '--type', 'hdd', '--medium', file_to_disk]
  
end
  
    config.vm.define :local do |config|
    config.vm.hostname = "devops.vagrant.vm"
  
  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # Static IP for testing.
  config.vm.network :private_network, ip: "172.16.16.17"
  config.vm.network :forwarded_port, guest: 22, host: 2132
  config.ssh.forward_agent = true
  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below, 
  # forward RDP , IIS and WINRM ports
  config.vm.network :forwarded_port, guest: 3389, host: 3378, id: "rdp", auto_correct: false
  config.vm.network :forwarded_port, guest: 80, host: 8082, id: "web", auto_correct: false
  config.vm.network :forwarded_port, guest: 5985, host: 5986, id: "winrm", auto_correct: true
  config.windows.set_work_network = true
  config.winrm.max_tries = 10
 
  # sync the folders you want (generally the SVN root)
  config.vm.synced_folder "wwwroot", "c:\inetpub\wwwroot"

  # Provisioning Secondary Disk
  config.vm.provision :shell, path: "scripts/formatDdisk.ps1"
  
  # Provisioning local DevBox we will need:
  # chocolatey,  IIS and other misc Dev tools:
  config.vm.provision :shell, path: "scripts/Install-Chocolatey.ps1"
  
  # ...in the path for all users:
  config.vm.provision :shell, inline: '[Environment]::SetEnvironmentVariable("Path", $env:Path + ";C:\Chocolatey\bin", "Machine")'

  # Installing Puppet:
  config.vm.provision :shell, path: "scripts/Install-Puppet.ps1"
  
  # Enable remoting in, useless if you uncommented "v.gui = true" above
   config.vm.provision :shell, path: "scripts/Enable-RDP.ps1"
   
  # Disable Firewall
  config.vm.provision :shell, path: "scripts/disablefirewall.ps1" 

  # Install AWS Powelshell Tools
  config.vm.provision :shell, path: "scripts/AWSPowerShellTool.ps1"

  # Configure Puppet client in local VM
  config.vm.provision :puppet do |puppet|
    puppet.facter = {
      "hostuser" => ENV['USERNAME']
    }
	puppet.manifests_path = "puppet/manifests"
    puppet.manifest_file = "init.pp"
	puppet.module_path = "puppet/modules"
    puppet.options = "--verbose --debug"
 end
  
  #Hostmanager will add the name and IP of the new VM into your host file
  config.vm.provision :hostmanager
end
end
