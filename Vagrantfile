# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  config.vm.box = "ubuntu/jammy64"

  config.hostmanager.enabled = true
  config.hostmanager.manage_host = true
  config.hostmanager.manage_guest = true
  config.hostmanager.ignore_private_ip = false
  config.hostmanager.include_offline = true

  # Fix static IPs not correctly set up under Fedora 36 and above
  # config.vm.provision "shell", inline: "dnf install -y NetworkManager-initscripts-ifcfg-rh && reboot"

  config.vm.define "snyssen.duckdns.org" do |apps|
    apps.vm.hostname = "snyssen.duckdns.org"
    apps.vm.network :private_network, ip: "192.168.56.12"

    # Adds one alias per subdomain
    subdomains = %w(routing dash recipes speedtest git drone cloud office photo streaming torrent usenet sonarr radarr lidarr prowlarr bazarr yt api-yt proxy-yt mc wiki dnd prometheus monitor)
      .map{|s| s+= ".snyssen.duckdns.org"}
    apps.hostmanager.aliases = subdomains

    # Adds disks
    apps.vm.disk :disk, size: "100GB", name: "parity1"
    apps.vm.disk :disk, size: "100GB", name: "disk1"
    apps.vm.disk :disk, size: "100GB", name: "disk2"
  end

  config.vm.define "backup.sny" do |backup|
    backup.vm.hostname = "backup.sny"
    backup.vm.network :private_network, ip: "192.168.56.13"

    backup.vm.disk :disk, size: "300GB", name: "storage"

    # Provision with Ansible
    backup.vm.provision "ansible" do |ansible|
      ansible.playbook = "setup-deploy.ansible.yml"
      ansible.galaxy_role_file = "requirements.yml"
      ansible.inventory_path = "hosts/dev.yml"
      ansible.limit = "all"
    end

  end

end
