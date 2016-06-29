# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'logger'
vm_resources = {
  'default_memory' => (ENV.fetch('VM_DEFAULT_MEM', 1.5).to_f *  1024).to_i.to_s,
  'default_cpus' => (ENV.fetch('VM_DEFAULT_CPUS', 2).to_i).to_s,

  'storage_memory' => (ENV.fetch('VM_STORAGE_MEM', 3).to_i *  1024).to_s,
  'storage_cpus' => (ENV.fetch('VM_STORAGE_CPUS', 2).to_i).to_s
}
logger = Logger.new(STDOUT)
logger.info "DEFAULT: Setting #{vm_resources['default_cpus']} CPUS"
logger.info "DEFAULT: Setting #{vm_resources['default_memory']} RAM"

logger.info "STORAGE: Setting #{vm_resources['storage_cpus']} CPUS"
logger.info "STORAGE: Setting #{vm_resources['storage_memory']} RAM"


Vagrant.configure('2') do |config|
  config.vm.box = 'ubuntu/trusty64'
  config.ssh.forward_agent = true
  config.ssh.forward_x11 = true

  config.vm.provider :virtualbox do |vb|

    # vb.gui = true
    vb.customize [
      'modifyvm', :id,
      '--memory', vm_resources['default_memory'],
      '--cpus', vm_resources['default_cpus'],
      '--natdnshostresolver1', 'on'
    ]
  end

  config.vm.define 'default' , primary: true do |default|
    default.vm.hostname = 'dev'
    default.vm.network 'private_network', ip: '192.168.34.10'
    # forward nrepl port so that we don't have to tunnel
    default.vm.network 'forwarded_port', guest: 4001, host: 4001
    default.vm.provision 'shell', path: 'bootstrap.sh'
  end

  config.vm.define 'storage', autostart: false do |storage|
    storage.vm.hostname = 'storage'
    storage.vm.network 'private_network', ip: '192.168.34.11'

    storage.vm.provision 'shell', path: 'bootstrap.sh'
    storage.vm.provision 'shell', path: 'storage-bootstrap.sh'

    storage.vm.provider :virtualbox do |vb|
      # vb.gui = true
      vb.customize [
        'modifyvm', :id,
        '--memory', vm_resources['storage_memory'],
        '--cpus', vm_resources['storage_cpus']
      ]
    end
  end
end
