%w(
weechat
vim-full
tmux
curl
libcurl4-openssl-dev
build-essential
make
git-core
).each { |pkg| package(pkg ) { action :install } }
