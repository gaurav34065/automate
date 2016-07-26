#!/bin/bash

# PLEASE EDIT THESE VARIABLES ACCORDING TO YOUR CHEF SETTINGS BEFORE RUNNING THE SCRIPT
VALIDATION_CLIENT="sbgs-validator"
CHEF_SERVER="https://api.chef.io/organizations/sbgs"


# Create a VM with given IP using vagrant/Virtualbox
spinUp()
{
	ip=$1
	n=$(($ip - 2))

	mkdir ~/mark/extraVM_$n
	cd ~/mark/extraVM_$n
	vagrant init
	echo "Copying validation_key.."
	cp ~/mark/${VALIDATION_CLIENT}.pem ~/mark/extraVM_$n/
	
	echo "
	# -*- mode: ruby -*-
	# vi: set ft=ruby :

	Vagrant.configure(2) do |config|

  	config.vm.box = \"base\"
  	config.vm.box = \"bento/ubuntu-14.04\"
    config.vm.hostname = \"extraVM-$n\"
    config.vm.network \"private_network\", ip: \"10.0.0.20$ip\"
	config.vm.define \"webserver$ip\" do |web|
    	web.vm.hostname = \"webserver$ip\"
    	web.vm.network \"private_network\", ip: \"10.0.0.20$ip\"

    	web.vm.provision :chef_client do |chef|
    		chef.node_name = \"webserver$ip\"
    		chef.chef_server_url = \"${CHEF_SERVER}\"
    		chef.validation_key_path = \"${VALIDATION_CLIENT}.pem\"
    		chef.validation_client_name = \"${VALIDATION_CLIENT}\"
    		chef.run_list = [\"recipe[webserver::default]\"]
    	end
    end

  	end "> Vagrantfile

	echo "Vagrantfile created.. Running vagrant up.."
	vagrant up
}

# Destroys a VM of given IP
spinDown()
{
	ip=$1
	n=$(($ip - 2))

	cd ~/mark/extraVM_$n
	vagrant halt webserver$ip
	#rm -r ~/mark/extraVM_$n

}

#-------------------------- START -----------------------------------#

ip=3
while true
	do
		cd ~/mark/scripts

		# get current spin up/down/nothing status 
		SPIN_STATUS="$(sed '2q;d' notifier)"

		# get current IP of machine to create/destroy
		CUR_IP="$(sed '3q;d' notifier)"

		# based on current spin status.. spin up/down a VM with given current IP and pass the info
		# to notifier file
		if [ "$SPIN_STATUS" -eq 1 ]; then
			
			CUR_IP="$(($CUR_IP + 1))"

			spinUp $CUR_IP
			echo "--------------New VM created with ip 10.0.0.20${CUR_IP} ------------------"

			cd ~/mark/scripts
			sed -i "3s/./${CUR_IP}/" notifier #ip number
			sed -i "4s/0/1/" notifier #on adder

			ip=$(($ip + 1))

		elif [ "$SPIN_STATUS" -eq -1 ]; then

			spinDown $CUR_IP
			echo "--------------VM halted with ip 10.0.0.20${CUR_IP} ------------------"

			CUR_IP="$(($CUR_IP - 1))"

			cd ~/mark/scripts
			sed -i "3s/./${CUR_IP}/" notifier #ip number
			sed -i "4s/0/-1/" notifier # on remover

		else
			echo "No addition/removal needed currently.."
		fi

		sleep 15
done


