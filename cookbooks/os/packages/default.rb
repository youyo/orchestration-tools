node.reverse_merge!({
  os: {
    packages: [
      "wget","bash-completion","screen","sysstat","dstat","vim-enhanced","openssh-server",
      "git","libtool","nc","sudo","logrotate","tar","ed"
    ]
  }
})

node[:os][:packages].each do |pkg|
  package pkg
end
