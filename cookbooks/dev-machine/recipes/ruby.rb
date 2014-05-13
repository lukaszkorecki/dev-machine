package "python-software-properties" do
  action :install
end

script "Add brightbox ppa" do
  user "root"
  group "root"
  interpreter "bash"
  code <<-EOF
  sudo apt-add-repository -y ppa:brightbox/ruby-ng
  sudo apt-get update
  EOF
end

%w{ ruby2.1 ruby-switch}.map do |p|
  package p do
    action :install
  end
end

execute "ruby-switch --set ruby2.1" do
  action :run
  user "root"
  not_if "ruby-switch --check | grep -q 'ruby2.1"
end

execute "gem install bundler pry" do
  action :run
  user "root"
end
