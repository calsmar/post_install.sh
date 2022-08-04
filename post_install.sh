#!/bin/bash 
#Created by Chris Harris

#  Post install script, I'm sure more to be added later.  Things like snort, sshd-server, etc
#  First off, we've gotta do an update & upgrade

sudo apt update
wait
sudo apt upgrade -yy
wait

echo "Installing stuff that the install didn't take care of...   Please wait."
sudo apt install ufw fail2ban ssh snort -yy
echo ""
echo "Enabling the universal firewall."
sudo systemctl enable ufw
echo ""
echo "Enabling your IDS system (fail2ban)"
sudo systemctl enable fail2ban
echo ""
echo "Enabling secure shell"
sudo systemctl enable ssh
echo ""
echo "Enabling intrusion protection system (snort)"
sudo systemctl enable snort
echo ""
echo "Setting up firewall rules."
sudo ufw allow ssh
sudo ufw allow http
sudo ufw allow https
echo "Enabling universal firewall in the user space"
sudo ufw enable

#  The systemctl lines should only echo if the services are active
echo ""
echo "Double checking to make sure that services are enabled..."
sudo systemctl is-active ufw --quiet && echo "Universal Firewall is enabled"
sudo ufw status
echo ""
sudo systemctl is-active fail2ban --quiet && echo "Intrusion detection system is enabled"
sudo systemctl is-active ssh --quiet && echo "Secure shell is enabled"
sudo systemctl is-active snort --quiet && echo "Intrusion protection system is enabled"
echo "Making a copy of /etc/fail2ban/jail.conf to /etc/fail2ban/jail.local"
#sudo cp /etc/fail2ban/jail.conf /etc/fail2ban.local

echo "Restarting the intrusion detection service..."
sudo systemctl restart fail2ban
echo "Making sure that it's still running..."
sudo systemctl is-active fail2ban --quiet && echo "Intrusion detection is still running..."



