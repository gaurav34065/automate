package 'haproxy' do
  action :install
end

package 'socat' do
  action :install
end

#edit haproxy.cfg
template "#{node['haproxy']['config_path']}/haproxy.cfg" do
  source 'haproxy.cfg.erb'
  variables ({
  			   :algorithm => node['haproxy']['algorithm'],
  			   :stats_enable => node['haproxy']['is_stats_enabled'],
  			   :stats_uri => node['haproxy']['stats_uri'],
  			   :backend_servers => node['haproxy']['backend_servers'],
           :socket => node['haproxy']['socket']
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

# run the backend processes/daemons
script 'run_haproxy_scripts' do
  interpreter 'bash'
  user 'root'
  cwd '/'
  code <<-EOH
  cd /vagrant/scripts
  ./lb_haproxy_stats_processor.sh >/vagrant/scripts/logs/lb_haproxy_stats_processor.out 2>/vagrant/scripts/logs/lb_haproxy_stats_processor.err &
  ./lb_haproxy_file_editor.sh >/vagrant/scripts/logs/lb_haproxy_file_editor.out 2>/vagrant/scripts/logs/lb_haproxy_file_editor.err &
  EOH
end
