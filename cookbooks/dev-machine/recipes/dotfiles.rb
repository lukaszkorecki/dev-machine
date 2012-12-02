directory node[:dotfiles][:path] do
  action :create
  user node[:user]
  group node[:user]
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

script "setup dot files" do
  interpreter "bash"
  user node[:user]
  cwd node[:dotfiles][:path]
  code "make setup"
  not_if { File.exists? "/home/#{node[:user]}/.private"}
end

script "update dot files" do
  interpreter "bash"
  user node[:user]
  cwd node[:dotfiles][:path]
  code "make update"
end
