exec { 'apt-get update':
  path => '/usr/bin',
}

class { 'elasticsearch':
  version => '1.3.4',
  java_install => true,
  manage_repo  => true,
  repo_version => '1.3',
  config => {
    'cluster.name' => 'esearch-testcluster',
  },
  require => Exec['apt-get update'],
}

elasticsearch::instance { 'esearch-testcluster':
  config => {
	'network.host' => "${guest_ip}",
    'index.number_of_shards' => "${number_of_shards}",
    'index.number_of_replicas' => "${number_of_replicas}",
	'marvel.agent.enabled' => false,
  },
  init_defaults => {
    'ES_HEAP_SIZE' => '384m',
  }
}

# thanks Jurgen ;)
exec { "intfd_esearch_plugin_version_installed_${plugin_version}":
  command    => "rm -rf /usr/share/elasticsearch/plugins/fp-extension; rm -f /var/lib/puppet/state/elasticsearch_intfd_version_installed_*.lock ; touch /var/lib/puppet/state/elasticsearch_intfd_version_installed_${plugin_version}.lock", #we remove the current directly as in esearch it is not versioned, I need to remove the previous lock as well so we can roll back easily.
  creates    => "/var/lib/puppet/state/elasticsearch_intfd_version_installed_${plugin_version}.lock",
  path       => '/bin:/usr/bin',
}
elasticsearch::plugin { 'fp-extension':
  module_dir => 'fp-extension',
  url        => "${plugin_url_prefix}${plugin_version}.zip",
  instances  => 'esearch-testcluster',
}

elasticsearch::plugin{ 'lmenezes/elasticsearch-kopf':
  module_dir => 'kopf',
  instances  => 'esearch-testcluster'
}

elasticsearch::plugin{ 'elasticsearch/marvel/latest':
  module_dir => 'marvel',
  instances  => 'esearch-testcluster'
}
