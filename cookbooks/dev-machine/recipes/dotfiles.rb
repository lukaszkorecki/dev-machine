git node[:dotfiles][:path] do
  repository node[:dotfiles][:path]
  revision 'master'
  action :sync
  user node[:user]
  group node[:user]
  not_if { File.exists? node[:dotfiles][:path] }
end

script "setup dot files" do
  interpreter "bash"
  user node[:user]
  pwd node[:dotfiles][:path]
  code "make setup"
  not_if { File.exists? "/home/#{node[:user]}/.private"}
end

script "update dot files" do
  interpreter "bash"
  user node[:user]
  pwd node[:dotfiles][:path]
  code "make update"
end
