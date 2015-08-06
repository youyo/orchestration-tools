require 'unix_crypt'

node.reverse_merge!({
  os: {
    user: [
      ["root","password","/root",{generate:false,keypass:"",publickey:""}]
    ]
  }
})

node[:os][:user].each do |userdata|

  user userdata[0] do
    action :create
    password UnixCrypt::SHA512.build(userdata[1], 'QW2My1VDiUSU4ADx')
    home userdata[2]
  end

  directory "#{userdata[2]}/.ssh" do
    owner "#{userdata[0]}"
    group "#{userdata[0]}"
    mode '0700'
  end

  file "#{userdata[2]}/.ssh/authorized_keys" do
    owner "#{userdata[0]}"
    group "#{userdata[0]}"
    mode '0600'
  end

  if userdata[3][:generate] == true
    execute "create ssh key #{userdata[0]}" do
      not_if "test -e #{userdata[2]}/.ssh/id_rsa"
      command "
        su - #{userdata[0]} -c \"ssh-keygen -q -t rsa -N '#{userdata[3][:keypass]}' -C '' -f #{userdata[2]}/.ssh/id_rsa\"
        su - #{userdata[0]} -c \"cat #{userdata[2]}/.ssh/id_rsa.pub >> #{userdata[2]}/.ssh/authorized_keys\"
      "
    end
  end

  if userdata[3][:publickey].size != 0
    execute "echo '#{userdata[3][:publickey]}' >> #{userdata[2]}/.ssh/authorized_keys" do
      not_if "grep -q -w '#{userdata[3][:publickey]}' #{userdata[2]}/.ssh/authorized_keys"
    end
  end

end
