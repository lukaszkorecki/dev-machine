%w(
  build-essential
  curl
  exuberant-ctags
  git-core
  libcurl4-openssl-dev
  make
  mutt
  tmux
  vim
  weechat
  watch
).each do |pkg|
  package(pkg) { action :install }
end
