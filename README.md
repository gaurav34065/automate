# automate
Devops Assignment

Solution Author : Gaurav Sharma (gsharma1@barclaycardus.com)

------------------------------------------------------------------------------------------------------------------

Description :-

This project uses vagrant/virtualbox to create and manage Virtual machines. To provision those machines i am using chef. For managing the even traffic on the application, i used HAproxy as a load balancer. And for the automated deployment i am using a cookbook which deploys the app on all servers in scope at a given time.  

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
Scripts :-

Three shell scripts. 

host_scaler.sh : Runs on host. Listens to notifier file in every 15 seconds and boots/halts the VM and updates notifier file accordingly.

lb_haproxy_stats_processor.sh : Runs on load-balancer as a daemon. Listens to haproxy stats 15 seconds and updates the notifier file accordingly.

lb_haproxy_file_editor.sh : Runs on load-balancer as a daemon. Listens to notifier file in every 10 seconds and update the haproxy config file based on the changes made by host_scaler.sh.

------------------------------------------------------------------------------------------------------------------

Usage :-

As i am using chef_client for provisioning, to use this you'll need to have a hosted chef account and chef installed along with vagrant and oracle virtual-box.

RENAME THE FOLDER FROM "automate-master" to "mark" and save the folder in your home directory. (~/mark)
Because i have written scripts that requires that exact path to execute the scripts.

1.) Install cygwin or gitbash to run bash commands on host machine.

2.) Configure below variables for your chef account before moving forward. (EDIT these variables in host_scaler.sh and parent Vagrantfile)

chef.chef_server_url = "https://api.chef.io/organizations/sbgs"
chef.validation_key_path = "sbgs-validator.pem"
chef.validation_client_name = "sbgs-validator"

3.) Push the cookbooks on your chef server using knife.

4.) Go to project diractory(~/mark in this case). Run a "vagrant up". This will download and boot three seperate VMs and provision them using cookbooks from chef server.

5.) In your host machine, from any browser you can access haproxy stats at "10.0.0.200:90/haproxy-stats".
Try hitting  load balancer at 10.0.0.200. It will re-direct it you to any of the backend server.

------------------------------------------------------------------------------------------------------------------

Test Autoscaling :-

1.) Two daemons starts executing automatically after the provisioning on load-balancer, we need to start a daemon on host also, go on ~/mark/scripts and execute
./host_scaler.sh to start host process/daemon.

2.)There is a loop.sh script which hits the haproxy infinitely until forcefully stopped. This is used to generate traffic on load-balancer. Run this in multiple windows of shell to increase the traffic.

3.)VM's get created and destroyed based on current traffic.

NOTE : Creation of a brand new VM takes time(creation + provisioning). Thus i am not destroying the VM when i scale down. Instead i am using vagrant halt to shud the VM down so that it can be used later.

------------------------------------------------------------------------------------------------------------------

