# Install required plugins
required_plugins = ["vagrant-hostsupdater"]
required_plugins.each do |plugin|
    exec "vagrant plugin install #{plugin}" unless Vagrant.has_plugin? plugin
end



Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/xenial64"
  config.vm.network "private_network", ip: "192.168.10.100"
  config.hostsupdater.aliases = ["development.local"]
  config.vm.synced_folder "app", "/home/ubuntu/app"
  config.vm.synced_folder "environment/app", "/home/ubuntu/environment"
  config.vm.provision "shell", path: "environment/app/provision.sh", privileged: false
end
