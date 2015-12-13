execute "Create swap file." do
  not_if "test -f /swapfile1"
  user 'root'
  command "
    dd if=/dev/zero of=/swapfile1 bs=1M count=1024
    chmow 600 /swapfile1
    mkswap /swapfile1
    swapon /swapfile1
  "
end

execute "echo -e '/swapfile1\tswap\tswap\tdefaults\t0 0' >> /etc/fstab" do
  not_if "grep -q -w swapfile1 /etc/fstab"
  user 'root'
end
