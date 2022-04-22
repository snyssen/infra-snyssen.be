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
  config.vm.box = "generic/fedora35"
  config.vm.hostname = "vagrant.sny"

  # config.vm.provider :virtualbox do |v|
  #   v.memory = 512
  # end

  # Disks are added here
  config.vm.disk :disk, name: "parity1", size: "10GB"
  config.vm.disk :disk, name: "disk1", size: "10GB"

  # Provision with Ansible
  config.vm.provision "ansible" do |ansible|
    ansible.playbook = "playbook.yml"
    ansible.galaxy_role_file = "requirements.yml"
    ansible.host_vars = {
      "vagrant.sny" => {
        "disks_mounts" => [
          {
            "path" => "",
            "src" => ""
          }
        ]
      }
    }
  end

end
