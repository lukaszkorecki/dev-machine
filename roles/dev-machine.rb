name 'dev-machine'
description 'Linux based dev VM, with my dot files!'

default_attributes(
  'user' => 'vagrant',
  'nfs-server' => {
    'mount-point' => File.join('home', 'vagrant', 'proj')
  }
)

run_list [
  'recipe[root_ssh_agent::ppid]',
  'recipe[dev-machine]',
  'recipe[nfs-server]'
]
