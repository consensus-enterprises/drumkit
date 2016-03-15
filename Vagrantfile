# -*- mode: ruby -*-
# vi: set ft=ruby :

conf = {}
conf_files = ['.mk/vagrant.yml', 'vagrant.yml']
conf_files.each do |c|
  if File.exists?(c)
    conf.merge!(YAML.load_file(c))
  end
end

Vagrant.configure(2) do |config|
  config.vm.define conf['name'] do |d|
    d.vm.box = conf['box']
    d.vm.provider "virtualbox" do |v|
      v.memory = conf['ram']
      v.cpus = conf['cpus']
    end

    d.vm.hostname = conf['hostname']
    d.vm.network 'private_network', ip: conf['IP']
    config.vm.network "forwarded_port", guest: conf['port'], host: 8888

    if Vagrant.has_plugin?("vagrant-cachier")
      config.cache.scope = :box
    end

    d.vm.provision "shell",
      path: ".mk/bootstrap.sh",
      privileged: false,
      keep_color: true
  end
end
