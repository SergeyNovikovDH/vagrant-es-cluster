# -*- mode: ruby -*-
# vi: set ft=ruby :

NUMBER_OF_NODES = 3
SUBNET = '172.29.125.'
PARAMS = {
  :plugin_version => '1.8',
  :plugin_url_prefix => 'CHANGEME!!!!',
  :number_of_shards => 1,
  :number_of_replicas => NUMBER_OF_NODES - 1,
  :host_ip => '172.29.125.1',
  :guest_ip => '',
  :node_name => '',
}

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  (1..NUMBER_OF_NODES).each do |node_number|
    parameters = PARAMS.clone
    parameters[:node_name] = sprintf("node%d", node_number)
    parameters[:guest_ip] = sprintf("%s%d", SUBNET, 100 + node_number)
    config.vm.define parameters[:node_name] do |node|
      node.vm.box = 'ubuntu/trusty64'
      node.vm.network :private_network, ip: parameters[:guest_ip]
      node.vm.hostname = parameters[:node_name]

      node.vm.provider :virtualbox do |vb|
        vb.cpus = 2
        vb.customize ["modifyvm", :id, "--cpuexecutioncap", "20"]
        vb.customize ["modifyvm", :id, "--memory", "1024"]
      end

      node.vm.provision :puppet, :facter => parameters do |puppet|
        puppet.manifests_path = 'manifests'
        puppet.module_path = 'modules'
        puppet.options = '--verbose'
      end
    end
  end
end
