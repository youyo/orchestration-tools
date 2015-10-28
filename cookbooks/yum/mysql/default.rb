case node[:platform_version]
when /^6/
  rpm_package_from_url 'http://dev.mysql.com/get/mysql-community-release-el6-5.noarch.rpm' do
    repo 'mysql56-community'
  end

when /^7/
  rpm_package_from_url 'http://dev.mysql.com/get/mysql-community-release-el7-5.noarch.rpm' do
    repo 'mysql56-community'
  end

end

if node[:platform] == "amazon"
  rpm_package_from_url 'http://dev.mysql.com/get/mysql-community-release-el6-5.noarch.rpm' do
    repo 'mysql56-community'
  end
end
