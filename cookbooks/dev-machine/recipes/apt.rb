script "Run apt-get update" do
  interpreter "bash"
  user "root"
  code "apt-get update"
end
