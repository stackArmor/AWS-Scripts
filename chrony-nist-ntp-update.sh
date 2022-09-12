#!/bin/bash

# Root check
if [ "$EUID" -ne 0 ]
  then echo "Please run as root" 
  exit
fi

# Backup current chrony config, format: Year Month Day Hour Minute Second
sudo cp /etc/chrony.conf /etc/chrony-$(date +"%Y%m%d%H%M%S").conf.bak

# Remove existing time servers/pools
sudo sed -i '/^pool/d' /etc/chrony.conf 
sudo sed -i '/^server/d' /etc/chrony.conf 

# Append NIST gov servers 
echo "
# NIST NTP Servers
# NIST, Gaithersburg, Maryland	
server time-d-g.nist.gov iburst	minpoll 8
server time-e-g.nist.gov iburst	minpoll 8
# NIST, Boulder, Colorado	
server time-d-b.nist.gov iburst	minpoll 8
server time-e-b.nist.gov iburst minpoll 8" >> /etc/chrony.conf

# Restart chrony to have the new servers take effect
systemctl restart chronyd