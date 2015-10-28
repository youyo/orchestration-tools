execute "Add Kernel Parameters" do
  not_if "test -e /tmp/itamae_tmp/KernelParameters"
  command "
    echo '' >> /etc/sysctl.conf
    echo '# Add Kernel Parameters' >> /etc/sysctl.conf
    echo 'vm.swappiness = 1' >> /etc/sysctl.conf
    echo 'fs.file-max = 320000' >> /etc/sysctl.conf
    echo 'net.netfilter.nf_conntrack_max = 2048000' >> /etc/sysctl.conf
    echo 'net.nf_conntrack_max = 2048000' >> /etc/sysctl.conf
    echo 'net.ipv4.ip_local_port_range = 10240    65535' >> /etc/sysctl.conf
    echo 'net.ipv4.tcp_tw_reuse = 1' >> /etc/sysctl.conf
    echo 'net.ipv4.tcp_fin_timeout = 10' >> /etc/sysctl.conf
    echo 'net.ipv4.tcp_tw_recycle = 0' >> /etc/sysctl.conf
    echo 'net.ipv4.tcp_keepalive_time = 20' >> /etc/sysctl.conf
    echo 'net.ipv4.tcp_keepalive_probes = 4' >> /etc/sysctl.conf
    echo 'net.ipv4.tcp_keepalive_intvl = 5' >> /etc/sysctl.conf
    echo 'net.core.somaxconn = 1024' >> /etc/sysctl.conf
    sysctl -e -p
  "
end

file "/tmp/itamae_tmp/KernelParameters"
