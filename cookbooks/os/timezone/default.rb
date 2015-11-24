execute "/bin/cp -a /usr/share/zoneinfo/Asia/Tokyo /etc/localtime" do
  not_if "diff /usr/share/zoneinfo/Asia/Tokyo /etc/localtime"
end

template '/etc/sysconfig/clock'
