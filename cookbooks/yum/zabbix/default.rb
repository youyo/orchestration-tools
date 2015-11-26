case node[:platform_version]
when /^5/
  rpm_package_from_url 'http://repo.zabbix.com/zabbix/2.2/rhel/5/x86_64/zabbix-release-2.2-1.el5.noarch.rpm' do
    repo 'zabbix'
  end

when /^6/
  rpm_package_from_url 'http://repo.zabbix.com/zabbix/2.2/rhel/6/x86_64/zabbix-release-2.2-1.el6.noarch.rpm' do
    repo 'zabbix'
  end

when /^7/
  rpm_package_from_url 'http://repo.zabbix.com/zabbix/2.2/rhel/7/x86_64/zabbix-release-2.2-1.el7.noarch.rpm' do
    repo 'zabbix'
  end

end

if node[:platform] == "amazon"
  rpm_package_from_url 'http://repo.zabbix.com/zabbix/2.2/rhel/6/x86_64/zabbix-release-2.2-1.el6.noarch.rpm' do
    repo 'zabbix'
  end
end
