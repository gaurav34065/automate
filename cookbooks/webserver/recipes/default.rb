package 'apache2' do
  action :install
end
service "apache2" do
  action [ :enable, :start ]
end

cookbook_file "/var/www/html/index.html" do
  source 'index.html'
end