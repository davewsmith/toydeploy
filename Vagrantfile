# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/bionic64"  # 18.04 LTS

  config.vm.network "forwarded_port", guest: 80, host: 8080
  # config.vm.network "private_network", ip: "192.168.33.10"

  config.vm.synced_folder ".", "/vagrant", disabled: true
  config.vm.synced_folder ".", "/home/vagrant/toydeploy"

  # See https://github.com/mitchellh/vagrant/issues/5005
  # config.ssh.insert_key = false

  config.vm.provider "virtualbox" do |vb|
    vb.name = "Toy Deploy"
    vb.memory = "1024"
    vb.cpus = 1
  end

  config.vm.provision "ansible" do |ansible|
    # ansible.verbose = "v"
    ansible.playbook = "provision/main.yml"
  end

end
