%w(zabbix-agent zabbix-sender zabbix-get).each {|pkg| package pkg}

%w(/var/lib/zabbix /etc/zabbix/bin).each do |dir|
  directory dir do
    owner 'zabbix'
    group 'zabbix'
    mode '0700'
  end
end

template '/etc/zabbix/zabbix_agentd.conf' do
  owner 'zabbix'
  group 'zabbix'
  mode '0644'
end

template '/etc/zabbix/bin/infokvm.sh' do
  owner 'zabbix'
  group 'zabbix'
  mode '0755'
end

service 'zabbix-agent' do
  action [:start, :enable]
end
