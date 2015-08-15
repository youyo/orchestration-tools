require 'unix_crypt'

node.reverse_merge!({
  os: {
    user: [
      ["root","password","/root",{generate:false,keypass:"",publickey:""}]
    ]
  }
})

node[:os][:user].each do |userdata|

  user userdata[:name] do
    action :create
    password UnixCrypt::SHA512.build(userdata[:password], 'QW2My1VDiUSU4ADx')
    home userdata[2]
  end

  directory "#{userdata[:homedir]}/.ssh" do
    owner "#{userdata[:name]}"
    group "#{userdata[:name]}"
    mode '0700'
  end

  file "#{userdata[:homedir]}/.ssh/authorized_keys" do
    owner "#{userdata[:name]}"
    group "#{userdata[:name]}"
    mode '0600'
  end

  if userdata[:authkey][:generate] == true
    execute "create ssh key #{userdata[:name]}" do
      not_if "test -e #{userdata[:homedir]}/.ssh/id_rsa"
      command "
        su - #{userdata[:name]} -c \"ssh-keygen -q -t rsa -N '#{userdata[:authkey][:keypass]}' -C '' -f #{userdata[:homedir]}/.ssh/id_rsa\"
        su - #{userdata[:name]} -c \"cat #{userdata[:homedir]}/.ssh/id_rsa.pub >> #{userdata[:homedir]}/.ssh/authorized_keys\"
      "
    end
  end

  if userdata[:authkey][:publickey].size != 0
    execute "echo '#{userdata[:authkey][:publickey]}' >> #{userdata[:homedir]}/.ssh/authorized_keys" do
      not_if "grep -q -w '#{userdata[:authkey][:publickey]}' #{userdata[:homedir]}/.ssh/authorized_keys"
    end
  end

end
