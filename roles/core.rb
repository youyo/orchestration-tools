include_recipe '../cookbooks/common-definitions/default.rb'
include_recipe './yum-repositories.rb'
include_recipe '../cookbooks/os/update/default.rb'
include_recipe '../cookbooks/os/hostname/default.rb'
include_recipe '../cookbooks/os/resolv/default.rb'
include_recipe './monitored.rb'
