package 'docker'

service 'docker' do
  action [:start,:enable]
end
