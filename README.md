# vagrant_kubernetes_libvirt_provider

This is a Vagrant file for creating a Kubernetes LAB with the ability to add worker nodes on the fly

* **The following are also done as part of the setup**
  * Install Helm
  * Setup NFS storage class

---

**CAUTION** -- If you're NOT using this Vagrant file as part of my course LABs, please comment or delete the following lines
```ruby
if File.stat("share").uid == 0
  FileUtils.chown_R 'orange', 'orange', 'share', verbose: true
end
```

---


## Instructions

💎 For creating the vm's for the first time; it's recommended to use `--no-parallel` option to make sure that the master vm is created before the worker nodes

```
vagrant up --no-parallel
```

💎 List the existing VMs

```
vagrant status
```
![image](https://user-images.githubusercontent.com/33789516/129351481-2eeb58e7-bd88-4be6-8fa1-bfc749f8ba70.png)


💎 Destroy a single VM

```
vagrant destroy -f worker-2
```


💎 Destroy all the VMs

```
vagrant destroy -f
```


💎 Shutdown all the VMs

```
vagrant halt
```

💎 Start all the VMs

```
vagrant up
```

---

🌼 To increase the number of worker nodes

```
vi Vagrantfile
```
Change `worker_nodes_number` number to the desired number of Worker nodes, then execute `vagrant up` to apply changes

![image](https://user-images.githubusercontent.com/33789516/129351873-37e37e04-d504-46e8-b2af-f394e7d727cb.png)

```
vagrant up
```

---

Thank you



