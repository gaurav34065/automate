#!/bin/bash

# Append server to haproxy config file
addServer()
{
	ip=$1

	sudo bash -c "echo '  server webserver$ip 10.0.0.20$ip:80 check' >> /etc/haproxy/haproxy.cfg"
}

# Removes server form haproxy config file
removeServer()
{
	sudo sed -i '$d' /etc/haproxy/haproxy.cfg
}


#-------------------------- START -----------------------------------#

while true;
do
		cd /vagrant/scripts 

		# get current ip to add/remove
		ip="$(sed '3q;d' notifier)"

		# get status either to add or remove
		BACKEND_STATUS="$(sed '4q;d' notifier)"

		# based on current backend status.. edit the haproxy config file and re-start it
		if [ "$BACKEND_STATUS" -eq 0 ]; then
			echo "No addition/removal needed currently.."

		elif [ "$BACKEND_STATUS" -eq 1 ]; then
			addServer $ip
			echo "--------------New server is added in haproxy with ip 10.0.0.20$ip ------------------"
			sudo service haproxy restart

			sed -i "4s/1/0/" notifier # off add_backend_status
			sed -i "2s/1/0/" notifier # off spin up

		else [ "$BACKEND_STATUS" -eq -1 ]
			removeServer
			echo "-------------- Server is removed from haproxy with ip 10.0.0.20$(($ip + 1)) ------------------"
			sudo service haproxy restart

			sed -i "4s/-1/0/" notifier # off remove_backend_status
			sed -i "2s/-1/0/" notifier # off spin down
		fi

	sleep 10
done


