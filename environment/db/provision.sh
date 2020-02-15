# be careful of these keys, they will go out of date
wget -qO - https://www.mongodb.org/static/pgp/server-4.2.asc | sudo apt-key add -

# adds the sting echoed to the path specified in the 'sudo tee'
echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu bionic/mongodb-org/4.2 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.2.list

# updates the source list for where ubuntu can look for software/repos
sudo apt-get update -y

# sudo apt-get install mongodb-org
sudo apt-get install -y mongodb-org

# remove the default .conf and replace with our configuration
sudo rm /etc/mongod.conf
sudo ln -s /home/ubuntu/environment/mongod.conf /etc/mongod.conf

# if mongo is is set up correctly these will be successful
sudo systemctl restart mongod
sudo systemctl enable mongod
