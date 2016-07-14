# automate
Devops Assignment

Solution Author : Gaurav Sharma (gsharma1@barclaycardus.com)

------------------------------------------------------------------------------------------------------------------

Description :-

This project uses vagrant/virtualbox to create and manage Virtual machines. To provision those machines i am using chef. For managing the even traffic on the application, i used HAproxy as a load balancer. And for the automated deployment i am using a cookbook which deploys the app on all servers in scope.  

------------------------------------------------------------------------------------------------------------------
CookBooks :-

1.) load-balancer
=> Provisions and configures the haproxy to balance the load on listed servers

2.)webserver
=> Installs the application, in this case there is a hello world web page.

------------------------------------------------------------------------------------------------------------------
Vagrantfile :-

Used to create VMs using oracle virtualbox. By default i have configured three VMs. One as a load balancer and other two as backend webservers. All have their private ip defined in this file.
load balancer : 10.0.0.200
webserver1    : 10.0.0.201
webserver2	  : 10.0.0.202

------------------------------------------------------------------------------------------------------------------

Usage :-

As i am using chef_client for provisioning, to use this you'll need to have a hosted chef account and chef installed. 

1.) Configure below variables for your chef account before moving forward.

chef.chef_server_url = "https://api.chef.io/organizations/sbgs"
chef.validation_key_path = "sbgs-validator.pem"
chef.validation_client_name = "sbgs-validator"

2.) Push the cookbooks on your chef server using knife.

3.) Run a "vagrant up". This will download and boot three seperate VMs and provision them using cookbooks from chef server.

4.) In your host machine, from any browser you can access haproxy stats at "10.0.0.200:90/haproxy-stats".
Try hitting  load balancer at 10.0.0.200. It will re-direct it you to any of the backend server.

------------------------------------------------------------------------------------------------------------------

