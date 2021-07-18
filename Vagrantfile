# -*- mode: ruby -*-
# vi: set ft=ruby :

## Variables ##

worker_nodes_number = 2
k8s_source_image    = "generic/ubuntu1804"
# k8s_source_image    = "kube-ready"
master_memory       = 4096
worker_memory       = 2048
haproxy_memory      = 1024
create_haproxy_vm   = false


##################  ##################  ##################

# Create a shared dir
# The shared dir is used to share the "join to master" script for all the new Nodes (Which allows us to add nodes at any time)
Dir.mkdir('share') unless File.directory?('share')

## Create the VMs ##

Vagrant.configure("2") do |config|
#   config.ssh.insert_key = false
    config.vm.define :master do |master|
    master.vm.box = "#{k8s_source_image}"
    master.vm.hostname = "master"
    #master.vm.network :public_network, :dev => "virbr0", :mode => "bridge", :type => "bridge", :ip => "192.168.122.90"
    master.vm.network :private_network, :ip => "10.0.0.90"
    master.vm.synced_folder './share', '/var/share'
    config.vm.provider :libvirt do |libvirt|
    libvirt.cpus = 2
    libvirt.memory = "#{master_memory}"
    # libvirt.management_network_device = 'virbr0'
    # libvirt.management_network_mode = "none"
    if k8s_source_image == "generic/ubuntu1804"
        master.vm.provision "install-k8s-components.sh", type: "shell", path: "scripts/install-k8s-components.sh"
    end
    master.vm.provision "initialize_cluster.sh", type: "shell", path: "scripts/initialize_cluster.sh"
    master.vm.provision "generate_join_command.sh", type: "shell", path: "scripts/generate_join_command.sh", run: "always"
    master.vm.provision "copy-master.sh", type: "shell", path: "scripts/copy-master.sh", run: "always"
    master.vm.provision "install-helm3.sh", type: "shell", path: "scripts/install-helm3.sh"
    master.vm.provision "install-nfs-server.sh", type: "shell", path: "scripts/install-nfs-server.sh"
        # Generate /ec/hosts of the master
        txt="""
127.0.0.1       localhost
127.0.1.1       master
10.0.0.90       master"""
        if worker_nodes_number > 0
            # for each worker node --> add entry
            (1..worker_nodes_number).each do |i|
            txt = "#{txt}\n" + "10.0.0.#{90 + i}       worker-#{i}"
            end
        end
        File.open('share/hosts', 'w') do |f|
            f.puts txt
        end
    end
  end

(1..worker_nodes_number).each do |i|
      config.vm.define "worker-#{i}" do |worker|
      worker.vm.box = "#{k8s_source_image}"
      worker.vm.hostname = "worker-#{i}"
      worker.vm.network :private_network, ip: "10.0.0.#{90 + i}"
      worker.vm.synced_folder './share', '/var/share'
      config.vm.provider :libvirt do |libvirt|
      libvirt.cpus = 2
      libvirt.memory = "#{worker_memory}"
    #   libvirt.management_network_device = 'virbr0'
    #   libvirt.management_network_mode = "none"
      if k8s_source_image == "generic/ubuntu1804"
        worker.vm.provision "install-k8s-components.sh", type: "shell", path: "scripts/install-k8s-components.sh"
      end
      worker.vm.provision "join-k8s-worker.sh" ,type: "shell", path: "scripts/join-k8s-worker.sh", privileged: true
    end
  end
end

if create_haproxy_vm
    config.vm.define "haproxy" do |haproxy|
      haproxy.vm.provider :virtualbox do |v|
        v.customize ["modifyvm", :id, "--memory", "#{haproxy_memory}"]
        v.customize ["modifyvm", :id, "--cpus", "2"]
        v.customize ["modifyvm", :id, "--name", "haproxy"]
      end
      haproxy.vm.hostname = "HAProxy"
      config.vm.box = "bento/ubuntu-18.04"
      haproxy.vm.network :public_network, bridge: "eth0", ip: "192.168.122.100"
      haproxy.vm.provision :shell, path: "scripts/install-haproxy.sh"
    end
  end
end
