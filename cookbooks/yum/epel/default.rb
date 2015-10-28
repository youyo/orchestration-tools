package 'epel-release'
enable_repo 'epel' if node[:platform] == "amazon"
