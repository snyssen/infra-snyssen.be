# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://vagrantcloud.com/search.
  config.vm.define "vagrant.sny"
  config.vm.box = "generic/fedora35"
  config.vm.hostname = "vagrant.sny"
  config.vm.network :private_network, ip: "192.168.56.12"

  # Adds disks
  config.vm.disk :disk, size: "100GB", name: "parity1"
  config.vm.disk :disk, size: "100GB", name: "disk1"
  config.vm.disk :disk, size: "100GB", name: "disk2"

  # Provision with Ansible
  config.vm.provision "ansible" do |ansible|
    ansible.playbook = "playbook.yml"
    ansible.galaxy_role_file = "requirements.yml"
    ansible.inventory_path = "hosts/dev.yml"
  end

end
