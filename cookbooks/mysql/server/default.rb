node.reverse_merge!({
  mysql: {
    server: {
      password: 'Passw0rd',
      innodb_buffer_pool_size: '64MB',
      innodb_log_file_size: '32MB',
      innodb_flush_log_at_trx_commit: 1,
      query_cache_size: '32MB',
      query_cache_type: 1,
      tmp_table_size: '32MB',
      max_heap_table_size: '32MB',
      max_connections: 256,
      thread_cache_size: 256,
      server_id: 1,
      expire_logs_days: 30
    }
  }
})

%w(mysql-community-server mysql-community-devel).each do |pkg|
  package pkg
end

%w(/var/run/mysqld /var/log/mysqld).each do |dir|
  directory dir do
    action :create
    owner 'mysql'
    group 'mysql'
    mode '0750'
  end
end

file '/var/log/mysqld.log' do
  action :delete
end

template '/etc/my.cnf' do
  owner 'root'
  group 'root'
  mode '0644'
end

service 'mysqld' do
  action [:start, :enable]
end

execute 'SecureInstall' do
  only_if "mysql -u root -e 'show databases'"
  command "
    mysqladmin -u root password \"#{node[:mysql][:server][:password]}\"
    mysql -u root -p#{node[:mysql][:server][:password]} -e \"DELETE FROM mysql.user WHERE User='';\"
    mysql -u root -p#{node[:mysql][:server][:password]} -e \"DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1');\"
    mysql -u root -p#{node[:mysql][:server][:password]} -e \"DROP DATABASE test;\"
    mysql -u root -p#{node[:mysql][:server][:password]} -e \"DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';\"
    mysql -u root -p#{node[:mysql][:server][:password]} -e \"GRANT ALL PRIVILEGES ON *.* TO 'root'@'127.0.0.1' IDENTIFIED BY '#{node[:mysql][:server][:password]}';\"
    mysql -u root -p#{node[:mysql][:server][:password]} -e \"FLUSH PRIVILEGES;\"
  "
end

template '/var/lib/zabbix/.my.cnf' do
  owner 'zabbix'
  group 'zabbix'
  mode '0640'
  notifies :restart, "service[zabbix-agent]"
end
