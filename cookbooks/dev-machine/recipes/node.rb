include_recipe 'dev-machine::ppa'

execute 'Add redis-server PPA' do
  command 'apt-add-repository ppa:chris-lea/node.js'
end

execute 'apt-get update' do
  command 'apt-get update'
end

package 'nodejs'do
  action :install
end
