execute "yum update -y" do
  not_if "test -e /tmp/itamae_tmp/OS_UPDATE"
end

file "/tmp/itamae_tmp/OS_UPDATE"
