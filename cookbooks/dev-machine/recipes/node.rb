include_recipe "dev-machine::ppa"

execute "Add redis-server PPA" do
  action :run
  command "apt-add-repository ppa:chris-lea/node.js"
end

execute "apt-get update" do
  command "apt-get update"
  action :run
end

%w{ nodejs npm}.each do |pkg|
  package pkg do
    action :install
  end
end


