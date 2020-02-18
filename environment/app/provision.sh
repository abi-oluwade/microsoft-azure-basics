#!/bin/bash

# Update the sources list
sudo apt-get update -y

# upgrade any packages available
sudo apt-get upgrade -y

# install nodejs
sudo apt-get install software-properties-common -y
curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -
sudo apt-get install nodejs -y
sudo apt install npm

# install pm2
sudo npm install pm2 -g

# # install nginx
# sudo apt-get install nginx -y
#
# # remove the old file and add our one
# sudo rm /etc/nginx/sites-available/default
# sudo cp /home/ubuntu/environment/nginx.default /etc/nginx/sites-available/default
#
# # finally, restart the nginx service so the new config takes hold
# sudo service nginx restart

# install apache
 sudo apt-get install apache2
 sudo systemctl reload apache2.service

# remove the old apache file and add new one
sudo rm /etc/apache2/sites-available/000-default.conf
sudo cp /home/ubuntu/environment/000-default.conf /etc/apache2/sites-available/000-default.conf

# make needed changes and then restart apache
sudo a2enmod proxy
sudo a2enmod proxy_http
sudo service apache2 restart
