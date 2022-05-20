# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  
  config.hostmanager.enabled = true
  config.hostmanager.manage_host = true
  config.hostmanager.manage_guest = true
  config.hostmanager.ignore_private_ip = false
  config.hostmanager.include_offline = true

  config.vm.define "vagrant.sny"
  config.vm.box = "generic/fedora35"
  config.vm.hostname = "vagrant.sny"
  config.vm.network :private_network, ip: "192.168.56.12"

  # Adds one alias per subdomain
  subdomains = %w(routing docker).map{|s| s+= ".vagrant.sny"}
  config.hostmanager.aliases = subdomains

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
