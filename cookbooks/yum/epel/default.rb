package 'epel-release'
execute "yum-config-manager --enable epel" if node[:platform] == "amazon"
