package 'haproxy' do
  action :install
end

#edit haproxy.cfg
template "#{node['haproxy']['config_path']}/haproxy.cfg" do
  source 'haproxy.cfg.erb'
  variables ({
  			   :algorithm => node['haproxy']['algorithm'],
  			   :stats_enable => node['haproxy']['is_stats_enabled'],
  			   :stats_uri => node['haproxy']['stats_uri'],
  			   :backend_servers => node['haproxy']['backend_servers']
  			})
  action :create
end

#enable haproxy
template "#{node['haproxy']['enable_path']}/haproxy" do
  source 'haproxy.erb'
  variables ({
  			   :haproxy_enabled => node['haproxy']['is_enabled']
  			})
  action :create
end

service 'haproxy' do
  action :restart
end

