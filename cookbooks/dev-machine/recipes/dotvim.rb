directory node[:dotvim][:path] do
  action :create
  user node[:user]
  group node[:user]
end

git node[:dotvim][:path] do
  repository node[:dotvim][:repo]
  revision 'HEAD'
  action :sync
  user node[:user]
  group node[:user]
end

execute "Setup dotvim" do
  action :run
  user node[:user]
  group node[:user]
  cwd node[:dotvim][:path]
  env({ "HOME" => "/home/#{node[:user]}" })
  command "make -C #{node[:dotvim][:path]} -f Makefile"
  not_if { File.exists? node[:dotvim][:path] }
end

execute "update dotvim" do
  action :run
  user node[:user]
  group node[:user]
  cwd node[:dotvim][:path]
  env({ "HOME" => "/home/#{node[:user]}" })
  command "make -C #{node[:dotvim][:path]} -f Makefile"
  only_if { File.exists? node[:dotvim][:path] }
end

