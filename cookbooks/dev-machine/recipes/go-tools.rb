execute "Install gotags" do
  action :run
  user node[:user]
  group node[:user]
  env({ "GOPATH" => "/home/#{node[:user]}/proj"})
  command "go get github.com/jstemmer/gotags && go install github.com/jstemmer/gotags"
end
