#
# Cookbook: confd
# License: Apache 2.0
#
# Copyright 2015-2016, Bloomberg Finance L.P.
#
include_recipe 'rc::default'

confd_config node['confd']['service_name'] do |r|
  path node['confd']['service']['config_file']

  node['confd']['config'].each_pair { |k, v| r.send(k, v) }
  notifies :restart, "confd_service[#{name}]", :delayed
end

file '["config_file"]'' do
  content '[confd]
  confdir = "/etc/confd/"
  prefix = "/"
  etcd_nodes = [
    "http://127.0.0.1:4001",
  ]'
  mode '0755'
  action :create_if_missing
end

file '["config_file"]/etcd.toml' do
  content '[template]
  src = "key.tmpl"
  dest = "/tmp/foo
  owner = "jpm"
  mode = "0600"
  keys = [
    "/foo",
  ]'
  mode '0755'
  action :create_if_missing
end 

confd_service node['confd']['service_name'] do |r|
  node['confd']['service'].each_pair { |k, v| r.send(k, v) }
end
