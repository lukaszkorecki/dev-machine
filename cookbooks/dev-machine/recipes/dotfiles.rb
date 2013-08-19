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
  revision 'HEAD'
  action :sync
  user node[:user]
  group node[:user]
end

script "Setup dotfiles" do
  user node[:user]
  cwd node[:dotfiles][:path]
  code <<-CODE
    export HOME=/home/#{node[:user]}
    make -k setup safe-update
  CODE
end
