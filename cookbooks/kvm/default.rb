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

%w(
  virt-manager tigervnc-server bridge-utils
  @base @development @virtualization @virtualization-client
  @virtualization-platform @virtualization-tools @x-window-system
  @desktop @japanese-support
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

template '/etc/init.d/vncserver' do
  owner 'root'
  group 'root'
  mode '0755'
end

directory '/root/.vnc'
execute "echo '2up78djo0gu9'|vncpasswd -f > /root/.vnc/passwd" do
  not_if "test -e /root/.vnc/passwd"
end

execute 'sed -i "s|^id:3|id:5|" /etc/inittab' do
  only_if 'grep -q "^id:3" /etc/inittab'
end

%w(vncserver libvirtd).each do |svc|
  service svc do
    action :enable
  end
end
