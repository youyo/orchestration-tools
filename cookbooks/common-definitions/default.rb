package 'yum-utils'

define :enable_repo do
  repo_name = params[:name]
  execute "yum-config-manager --enable #{repo_name}"
end

define :disable_repo do
  repo_name = params[:name]
  execute "yum-config-manager --disable #{repo_name}"
end

define :rpm_package_from_url, repo: nil do
  url = params[:name]
  repo_name = params[:repo]
  package url do
    only_if "test 0 -eq `yum-config-manager --showduplicates -q #{repo_name}|wc -l`"
  end
end

define :install_and_enable_package do
  pkg = params[:name]
  package pkg
  service pkg do
    action :enable
  end
end

define :install_and_enable_and_start_package do
  pkg = params[:name]
  package pkg
  service pkg do
    action [:enable,:start]
  end
end

define :disable_daemon do
  daemon  = params[:name]
  service daemon do
    only_if "chkconfig --list #{daemon}"
    action [:stop, :disable]
  end
end
