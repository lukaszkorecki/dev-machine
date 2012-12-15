%w( python2.7 python2.7-dev python-pip).each do |pkg|
  package(pkg) { action :install }
end

