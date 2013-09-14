include_recipe "dev-machine::ppa"

execute "Add redis-server PPA" do
  command "apt-add-repository ppa:gophers/go"
end

execute "apt-get update" do
  action :run
end

package "golang" do
  action :install
end

# Go source will live here
directory "/home/#{node[:user]}/proj/src" do
  action :create
end
