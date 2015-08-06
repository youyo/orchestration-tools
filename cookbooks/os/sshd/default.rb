node.reverse_merge!({
  os: {
    sshd: {
      port: 10022,
      permitrootlogin: 'no',
      passwordauth: 'no'
    }
  }
})

service 'sshd' do
  action [:start, :enable]
end

template '/etc/ssh/sshd_config' do
  notifies :restart, "service[sshd]"
end
