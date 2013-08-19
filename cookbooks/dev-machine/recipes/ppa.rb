apt_package "python-software-properties" do
  action :install
end

execute "apt-get update" do
  command "apt-get update"
  action :run
end
