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
  }
)

run_list [
  "recipe[root_ssh_agent::ppid]",
  "recipe[dev-machine]",
  "recipe[dev-machine::python]",
  "recipe[dev-machine::golang]",
  "recipe[dev-machine::go-tools]",
  "recipe[dev-machine::node]"
]
