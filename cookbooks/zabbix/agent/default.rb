node.reverse_merge!({
  zabbix: {
    agent: {
      server: ['127.0.0.1'],
      allow_root: 0
    }
  }
})

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
  @servers = node[:zabbix][:agent][:server].join(',')
  variables(zabbix_servers: @servers)
end

template '/etc/zabbix/bin/infokvm.sh' do
  owner 'zabbix'
  group 'zabbix'
  mode '0755'
end

service 'zabbix-agent' do
  action [:start, :enable]
end
