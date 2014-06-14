loc = File.join "/home", node[:user],"proj", "git-surf"
directory loc do
  action :create
  user node[:user]
  group node[:user]
  recursive true
end

git loc do
  repository "git@github.com:lukaszkorecki/git-surf.git"
  revision 'master'
  action :sync
  user node[:user]
  group node[:user]
end

execute "Install git surf" do
  action :run
  cwd loc
  command "sudo make install"
  not_if { `which git-surf`.strip.chomp.empty? }
end
