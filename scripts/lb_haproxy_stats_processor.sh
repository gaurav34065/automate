#!/bin/bash


# process the haproxy stats and put desired output in /vagrant/stats file
processStats()
{
	echo "show stat" | sudo socat unix-connect:/var/run/haproxy.stat stdio > /vagrant/stats
	sudo sed -n "4p" /vagrant/stats > /vagrant/temp
	cat /vagrant/temp > /vagrant/stats
}


#-------------------------- START -----------------------------------#

#stores the session rate
threshold=(0 40 55 70)

i=0

#create a stat file to process haproxy stats
sudo touch /vagrant/stats

while true;
	do
		# process the haproxy stats and put desired output in /vagrant/stats file
		processStats

		# get current session rate from above stat file 
		CUR_RATE="$(sudo awk -F',' '{print $47}' /vagrant/stats)"

		# get current spin status from notifier file
		SPIN_STATUS="$(sed '2q;d' notifier)"

		# get current min/max threshold for spinning VM
		MIN_THRESH=${threshold[i]}
		MAX_THRESH=${threshold[i+1]}

		# based on current session rate and spin status.. edit the notifier file for host daemon
		if [[ -z "$CUR_RATE" ]] || [ "$CUR_RATE" -eq 0 ]; then
			sleep 5
			continue
		fi

		echo "CUR_RATE : ${CUR_RATE} MIN_THRESH : ${MIN_THRESH} MAX_THRESH : ${MAX_THRESH}"
		
		if [ "$CUR_RATE" -gt "$MAX_THRESH" ] && [ "$SPIN_STATUS" -eq 0 ]; then

			sed -i "2s/0/1/" /vagrant/scripts/notifier #on spin up
			i=$(($i + 1)) # update the new threshold value

			echo "VM added"

		elif [ "$CUR_RATE" -lt "$MIN_THRESH" ] && [ "$SPIN_STATUS" -eq 0 ]; then

			sed -i "2s/0/-1/" /vagrant/scripts/notifier #on spin down
			i=$(($i - 1)) # update the new threshold value

			echo "VM removed"

		else
			echo "No addition/removal needed currently.."
		fi
		
		sleep 15
done