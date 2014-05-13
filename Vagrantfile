# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "dev-box"
  config.vm.box_url = "http://f.willianfernandes.com.br/vagrant-boxes/UbuntuServer12.04amd64.box"

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
  # use berkshelf wiith chef.
  # install with
  #   vagrant plugin install vagrant-berkshelf --plugin-version 2.0.1
  config.berkshelf.enabled = true
  config.vm.provision :chef_solo do |chef|
    chef.cookbooks_path     = "cookbooks"
    chef.roles_path         = "roles"
    chef.add_role             "dev-machine"
  end
end
