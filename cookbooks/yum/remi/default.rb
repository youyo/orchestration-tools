case node[:platform_version]
when /^6/
  rpm_package_from_url 'http://rpms.famillecollet.com/enterprise/remi-release-6.rpm' do
    repo 'remi'
  end

when /^7/
  rpm_package_from_url 'http://rpms.famillecollet.com/enterprise/remi-release-7.rpm' do
    repo 'remi'
  end

end
