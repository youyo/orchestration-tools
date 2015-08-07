template "/etc/selinux/config"

execute "setenforce 0" do
  only_if "getenforce | grep -q -w Enforcing"
end
