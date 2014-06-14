# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "dev-box"
  config.vm.box_url = "hashicorp/precise64"

  config.vm.synced_folder "bridge", "/home/vagrant/bridge"

  config.vm.hostname = "dev-box"
  config.ssh.forward_agent = true
  config.vm.network :private_network, ip: "192.168.33.10"

  # make the vm faster
  config.vm.provider :virtualbox do |vb|
    vb.customize [
      "modifyvm", :id,
      "--memory", (1 * 1024).to_s,
      "--cpus", 1
    ]

    # and enable symlinks in shared folders
    vb.customize [
      'setextradata', :id,
      'VBoxInternal2/SharedFoldersEnableSymlinksCreate/bridge', 1
    ]

  end

  # Chefit
  config.vm.provision :chef_solo do |chef|
    chef.cookbooks_path     = "cookbooks"
    chef.roles_path         = "roles"
    chef.add_role             "dev-machine"
  end
end
