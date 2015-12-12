node.reverse_merge!({
  os: {
    hostname: 'localhost.localdomain'
  }
})

case node[:platform_version]
when /^6|^5/
  execute "hostname #{node[:os][:hostname]}" do
    not_if "hostname --fqdn|grep -w #{node[:os][:hostname]}"
  end
  execute "sed -i \"s|HOSTNAME=.*|HOSTNAME=#{node[:os][:hostname]}|\" /etc/sysconfig/network" do
    not_if "grep -q -w \"#{node[:os][:hostname]}\" /etc/sysconfig/network"
  end

when /^7/
  execute "hostnamectl set-hostname #{node[:os][:hostname]}" do
    not_if "hostname --fqdn|grep -w #{node[:os][:hostname]}"
  end

end

case node[:platform]
when "amazon"
  execute "hostname #{node[:os][:hostname]}" do
    not_if "hostname --fqdn|grep -w #{node[:os][:hostname]}"
  end
  execute "sed -i \"s|HOSTNAME=.*|HOSTNAME=#{node[:os][:hostname]}|\" /etc/sysconfig/network" do
    not_if "grep -q -w \"#{node[:os][:hostname]}\" /etc/sysconfig/network"
  end
end

template '/etc/hosts' do
  owner 'root'
  group 'root'
  mode '0644'
end
