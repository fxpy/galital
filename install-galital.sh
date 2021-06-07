#!/bin/bash
#
#Galital Validator Node installer

read -p "Enter Galital node name: " GALITAL_NODENAME

echo 'Galital node starting install...'

sudo apt update && sudo apt upgrade -y < "/dev/null"
sudo ntpq -p
sudo apt install -y ufw curl chrony 
sudo systemctl enable chrony
sudo apt install -y fail2ban
sudo systemctl enable fail2ban
sudo service fail2ban start 

echo 'Opening ssh port 22...'
sudo ufw allow 22 
echo 'Opening galital port 30333...'
sudo ufw allow 30333
echo 'Enabling firewall... Press Y to continue...'
sudo ufw enable

echo 'Installing binaries...'
wget https://github.com/starkleytech/galital/releases/download/2.0.1/galital && sudo chmod +x ./galital && sudo mv ./galital /usr/bin/galital

echo 'Input password and info for galital user. You may leave fields blank...'
echo ''
sudo adduser galital

echo 'Adding config file...'
sudo tee <<EOF >/dev/null /lib/systemd/system/galital.service

[Unit]
Description=Galital Validator
After=network-online.target

[Service]
ExecStart=/usr/bin/galital --port '30333' --name '$GALITAL_NODENAME | MMS' --validator --chain galital   
User=galital
Restart=always
ExecStartPre=/bin/sleep 5
RestartSec=30s
LimitNOFILE=8192

[Install]
WantedBy=multi-user.target
EOF

echo 'Loading services...'
sudo systemctl daemon-reload
sudo systemctl enable galital
sudo service galital start 

echo 'Waiting Galital Validator to start... Press Ctrl+C when ready'
sleep 3

journalctl -u galital | grep "Local node identity is: " | awk -F "[, ]+" '/Local node identity is: /{print $NF}' > galital_node_id.txt

echo 'Your local node identity saved to galital_node_id.txt file'
journalctl -u galital -f
