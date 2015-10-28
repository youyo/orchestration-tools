case node[:platform_version]
when /^6/
  rpm_package_from_url 'http://nginx.org/packages/centos/6/noarch/RPMS/nginx-release-centos-6-0.el6.ngx.noarch.rpm' do
    repo 'nginx'
  end

when /^7/
  rpm_package_from_url 'http://nginx.org/packages/centos/7/noarch/RPMS/nginx-release-centos-7-0.el7.ngx.noarch.rpm' do
    repo 'nginx'
  end

end

if node[:platform] == "amazon"
  rpm_package_from_url 'http://nginx.org/packages/centos/6/noarch/RPMS/nginx-release-centos-6-0.el6.ngx.noarch.rpm' do
    repo 'nginx'
  end
end
