case node[:platform_version]
when /^6/
  include_recipe '../owncloud-os6/default.rb'

when /^7/
  include_recipe '../owncloud-os7/default.rb'

end
