node.reverse_merge!({
  kvm: {
    nic: [
      [
        name: "eth0",
        ip: "192.168.1.10",
        netmask: "255.255.255.0",
        gw: "192.168.1.1"
      ]
    ]
  }
})

case node[:platform_version]
when /^6/
  package 'iptables'
when /^7/
  package 'iptables-services'
end

%w(
  bridge-utils @base @virtualization @virtualization-client
  @virtualization-platform @virtualization-tools
).each {|pkg| package pkg}

node[:kvm][:nic].each_with_index do |nic,index|
  execute "set_interface:#{nic[:name]}" do
    command "
cat <<EOL> /etc/sysconfig/network-scripts/ifcfg-#{nic[:name]}
DEVICE=#{nic[:name]}
ONBOOT=yes
BRIDGE=br#{index}
BOOTPROTO='static'
EOL
    "
  end

  case nic.size
  when 4
    execute "set_interface:br#{index}" do
      command "
cat <<EOL> /etc/sysconfig/network-scripts/ifcfg-br#{index}
BOOTPROTO=none
NETMASK=#{nic[:netmask]}
ONBOOT=yes
DEVICE=br#{index}
IPADDR=#{nic[:ip]}
GATEWAY=#{nic[:gw]}
IPV6INIT=no
TYPE=Bridge
EOL
    "
  end

  when 3
    execute "set_interface:br#{index}" do
      command "
cat <<EOL> /etc/sysconfig/network-scripts/ifcfg-br#{index}
BOOTPROTO=none
NETMASK=#{nic[:netmask]}
ONBOOT=yes
DEVICE=br#{index}
IPADDR=#{nic[:ip]}
IPV6INIT=no
TYPE=Bridge
EOL
      "
    end
  end
end

service 'libvirtd' do
  action [:start, :enable]
end

execute 'stop_default_network' do
  only_if "virsh net-list --all | grep -w 'default' | grep -w 'active'"
  command "
    virsh net-destroy default
    virsh net-autostart default --disable
  "
end

%w(NetworkManager dnsmasq iptables ip6tables firewalld).each do |srv|
  service srv do
    action [:stop, :disable]
  end
end
