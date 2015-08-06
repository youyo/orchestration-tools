node.reverse_merge!({
  os: {
    resolv: [
      '8.8.8.8',
      '8.8.4.4'
    ]
  }
})

case node[:platform_version]
when /^6/
  template "/etc/resolv.conf" do
    owner 'root'
    group 'root'
    mode '0644'
  end

end
