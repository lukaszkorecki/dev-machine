include_recipe "dev-machine::ppa"

execute "Add redis-server PPA" do
  action :run
  command "apt-add-repository ppa:gophers/go"
end

execute "apt-get update" do
  command "apt-get update"
  action :run
end

package "golang-stable" do
  action :install
end
