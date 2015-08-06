install_and_enable_package 'ntpdate'
package 'ntp'

template '/etc/ntp.conf' do
  notifies :restart, "service[ntpd]"
end

service 'ntpd' do
  action [:start,:enable]
end
