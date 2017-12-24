# -*- mode: ruby -*-
# vi: set ft=ruby :
nguests = 2
box = "hashicorp/precise64"
memory = 8256/nguests # memory per box in MB
cpuCap = 100/nguests
ipAddressStart = '192.168.1.5'
Vagrant.configure("2") do |config|
  (1..nguests).each do |i|
    hostname = 'guest' + i.to_s
    ipAddress = ipAddressStart + i.to_s
    config.vm.define hostname do |hostconfig|
      hostconfig.vm.box = box
      hostconfig.vm.hostname = hostname
      hostconfig.vm.network :private_network, ip: ipAddress
      hostconfig.vm.provider :virtualbox do |vb|
        vb.customize ["modifyvm", :id, "--cpuexecutioncap", cpuCap, "--memory", memory.to_s]
      end
      hostconfig.vm.provision :shell, path: "scripts/bootstrap.sh", args: [nguests, i, memory, ipAddressStart]
    end
  end
end
