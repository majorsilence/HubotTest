# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # please see the online documentation at vagrantup.com.

  config.vm.define "hubot" do |hubot|
    # Every Vagrant virtual environment requires a box to build off of.
    hubot.vm.box = "trusty64"
    hubot.vm.provision :shell, :path => "ubuntu_bootstrap.sh"

    # create a /sites directory on the server that is linked to the current
    # directory of the Vagrantfile
    hubot.vm.synced_folder "./", "/hostmount"

    # The url from where the 'config.vm.box' box will be fetched if it
    # doesn't already exist on the user's system.
    hubot.vm.box_url = "https://cloud-images.ubuntu.com/vagrant/trusty/current/trusty-server-cloudimg-amd64-vagrant-disk1.box"

    # Create a forwarded port mapping which allows access to a specific port
    # within the machine from a port on the host machine. In the example below,
    # accessing "localhost:8080" will access port 80 on the guest machine.
    hubot.vm.network :forwarded_port, guest: 8080, host: 3030
    
  end

end
