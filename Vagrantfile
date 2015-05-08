# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure('2') do |config|
  config.vm.box = 'ubuntu/trusty64'
  config.ssh.forward_agent = true

  config.vm.provider :virtualbox do |vb|
    # vb.gui = true
    vb.customize [
      'modifyvm', :id,
      '--memory', (1.5 * 1024).to_i.to_s,
      '--cpus', 1,
      '--natdnshostresolver1', 'on'
    ]
  end

  config.vm.define 'default' do |default|
    default.vm.synced_folder 'bridge', '/home/vagrant/bridge'
    default.vm.hostname = 'dev'
    default.vm.network 'private_network', ip: '192.168.34.10'
    default.vm.provision 'shell', path: 'bootstrap.sh'
  end

  config.vm.define 'storage' do |storage|
    storage.vm.hostname = 'storage'
    storage.vm.network 'private_network', ip: '192.168.34.11'
    storage.vm.provision 'shell', path: 'storage-bootstrap.sh'

    storage.vm.provider :virtualbox do |vb|
      # vb.gui = true
      vb.customize [
        'modifyvm', :id,
        '--memory', '512',
        '--cpus', 1
      ]
    end
  end
end
