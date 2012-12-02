# This recipe install ruby 1.9.3 (even though the package name says something
# different) and changes the default interpreter so that ruby 1.9.3 becomes
# the system wide ruby and 1.8.7 is stuck in chef's opt dir
%w( ruby1.9.1 ruby1.9.1-dev).each { |pkg| package(pkg)  { action :install } }

script "Update alternatives and make 1.9.3 the default" do
  interpreter "bash"
  user 'root'
  code <<-EOH
     sudo update-alternatives --install /usr/bin/ruby ruby /usr/bin/ruby1.9.1 400 \
             --slave   /usr/share/man/man1/ruby.1.gz ruby.1.gz \
                            /usr/share/man/man1/ruby1.9.1.1.gz \
            --slave   /usr/bin/ri ri /usr/bin/ri1.9.1 \
            --slave   /usr/bin/irb irb /usr/bin/irb1.9.1 \
            --slave   /usr/bin/rdoc rdoc /usr/bin/rdoc1.9.1

     sudo update-alternatives --config ruby
     sudo update-alternatives --config gem
  EOH
end
