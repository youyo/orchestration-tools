package 'iptables'

service 'iptables' do
    action [:stop,:disable]
end
