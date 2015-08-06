node.reverse_merge!({
  os: {
    hostname: 'localhost.localdomain'
  }
})

case node[:platform_version]
when /^6/
  execute "hostname #{node[:os][:hostname]}" do
    not_if "hostname --fqdn|grep -w #{node[:os][:hostname]}"
  end
  execute "sed -i \"s|HOSTNAME=.*|HOSTNAME=#{node[:os][:hostname]}|\" /etc/sysconfig/network" do
    not_if "grep \"#{node[:os][:hostname]}\" /etc/sysconfig/network|awk -F'=' '{print $2}'"
  end

when /^7/
  execute "hostnamectl set-hostname #{node[:os][:hostname]}" do
    not_if "hostname --fqdn|grep -w #{node[:os][:hostname]}"
  end

end

template '/etc/hosts'
