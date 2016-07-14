default['haproxy']['is_enabled'] = true
default['haproxy']['enable_path'] = '/etc/default'
default['haproxy']['config_path'] = '/etc/haproxy'
default['haproxy']['algorithm'] = 'roundrobin'
default['haproxy']['is_stats_enabled'] = true
default['haproxy']['stats_uri'] = '/haproxy-stats'
default['haproxy']['backend_servers'] = ["10.0.0.201","10.0.0.202"]
