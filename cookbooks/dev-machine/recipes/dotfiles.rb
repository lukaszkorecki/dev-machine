directory node[:dotfiles][:path] do
  action :create
  user node[:user]
  group node[:user]
end

user node[:user] do
  action :modify
  shell "/bin/zsh"
end

template "/home/#{node[:user]}/.ssh/config" do
  source "sshconfig.erb"
  user node[:user]
  group node[:user]
end

git node[:dotfiles][:path] do
  repository node[:dotfiles][:repo]
  revision 'master'
  action :sync
  user node[:user]
  group node[:user]
  not_if { File.exists? "/home/#{node[:user]}/.vimrc"}
end

script "create symlinks" do
  interpreter "zsh"
  user node[:user]
  cwd node[:dotfiles][:path]
  code <<-CODE
    export HOME=/home/#{node[:user]}
    make link
  CODE

  not_if { File.exists? "/home/#{node[:user]}/.vimrc"}
end
