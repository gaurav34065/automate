# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|

  config.vm.box = "base"
  config.vm.box = "bento/ubuntu-14.04"

  config.vm.define "load-balancer" do |lb|
    lb.vm.hostname = "load-balancer"
    lb.vm.network "private_network", ip: "10.0.0.200"

    lb.vm.provision :chef_client do |chef|
    chef.node_name = 'load-balancer'
    chef.chef_server_url = "https://api.chef.io/organizations/sbgs"
    chef.validation_key_path = "sbgs-validator.pem"
    chef.validation_client_name = "sbgs-validator"
    chef.run_list = ["recipe[load-balancer::default]"]
    end
  end

  config.vm.define "webserver1" do |web|
    web.vm.hostname = "webserver1"
    web.vm.network "private_network", ip: "10.0.0.201"

    web.vm.provision :chef_client do |chef|
    chef.node_name = 'webserver1'
    chef.chef_server_url = "https://api.chef.io/organizations/sbgs"
    chef.validation_key_path = "sbgs-validator.pem"
    chef.validation_client_name = "sbgs-validator"
    chef.run_list = ["recipe[webserver::default]"]
    end
  end

  config.vm.define "webserver2" do |web|
    web.vm.hostname = "webserver1"
    web.vm.network "private_network", ip: "10.0.0.202"

    web.vm.provision :chef_client do |chef|
    chef.node_name = 'webserver2'
    chef.chef_server_url = "https://api.chef.io/organizations/sbgs"
    chef.validation_key_path = "sbgs-validator.pem"
    chef.validation_client_name = "sbgs-validator"
    chef.run_list = ["recipe[webserver::default]"]
    end
  end

end
