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

%w{ ruby2.1 libruby2.1 ruby2.1-dev ruby-switch}.map do |p|
  package p do
    action :install
  end
end

execute "ruby-switch --set ruby2.1" do
  action :run
  user "root"
  not_if "ruby-switch --check | grep -q 'ruby2.1"
end

%w{ bundler pry }.each do |gm|
  execute "gem install #{gm}" do
    action :run
    user "root"
  end
end
