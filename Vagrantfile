# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/focal64"  # 20.04 LTS

  if Vagrant.has_plugin?("vagrant-cachier")
    config.cache.scope = :box
    # https://github.com/fgrehm/vagrant-cachier/issues/175#issuecomment-260373281
    config.cache.synced_folder_opts = {
       owner: "_apt",
    }
  end

  config.vm.network "forwarded_port", guest: 80, host: 8080
  # config.vm.network "private_network", ip: "192.168.33.10"

  # config.vm.synced_folder ".", "/vagrant", disable=true
  config.vm.synced_folder "data", "/opt/data"  # for db

  config.vm.provider "virtualbox" do |vb|
    vb.name = "toydeploy"
    vb.memory = "1024"
    vb.cpus = 1
  end

  config.vm.provision "ansible" do |ansible|
    # ansible.verbose = "v"
    ansible.playbook = "__provision__/ansible/playbooks/main.yml"
  end

end
