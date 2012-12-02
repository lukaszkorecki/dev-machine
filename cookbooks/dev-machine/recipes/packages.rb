%w(
weechat
vim
tmux
curl
libcurl4-openssl-dev
build-essential
make
git-core
).each do |pkg|
  package(pkg) { action :install }
end
