git node[:dotfiles][:path] do
  repository node[:dotfiles][:path]
  revision 'master'
  action :sync
  user node[:user]
  group node[:user]
  not_if { File.exists? node[:dotfiles][:path] }
end
