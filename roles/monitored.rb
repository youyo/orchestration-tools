include_recipe '../cookbooks/common-definitions/default.rb'
include_recipe './yum-repositories.rb'
include_recipe '../cookbooks/zabbix/agent/default.rb'
