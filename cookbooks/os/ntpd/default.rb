case node[:platform_version]
when /^6|^7/
  install_and_enable_package 'ntpdate'
end

package 'ntp'

template '/etc/ntp.conf' do
  notifies :restart, "service[ntpd]"
end

service 'ntpd' do
  action [:start,:enable]
end
