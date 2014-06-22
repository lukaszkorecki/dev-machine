name "dev-machine"
description "Linux based dev VM, with my dot files!"

default_attributes(
  "user" => "vagrant",
  "dotfiles" => {
    "path" => "/home/vagrant/.DotFiles",
    "repo" => "git@github.com:lukaszkorecki/DotFiles"
  },
  "dotvim" => {
    "path" => "/home/vagrant/.vim",
    "repo" => "git@github.com:lukaszkorecki/DotVim"
  },
  "nfs-server" => {
    "mount-point" => File.join("home", "vagrant", "proj")
  }
)

run_list [
  "recipe[root_ssh_agent::ppid]",
  "recipe[dev-machine]",
  "recipe[nfs-server]"
]
