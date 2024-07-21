ncreases the amount of traffic an Nginx server can handle.

# Increase the ULIMIT of the default file
exec { 'fix--for-nginx':
  command => '/bin/sed -i "s/15/4096/" /etc/default/nginx',
  path    => '/usr/local/bin/:/bin/',
}
# Update Nginx configuration to handle 1000 connections with 100 requests at a time
file { '/etc/nginx/nginx.conf':
  ensure  => present,
  content => template('nginx/nginx.conf.erb'),
  notify  => Exec['nginx-reload'],
}

# Reload Nginx to apply configuration changes
exec { 'nginx-reload':
  command => 'nginx -s reload',
  path    => ['/usr/bin', '/usr/sbin'],
  refreshonly => true,
}
#->
# Restart Nginx
exec { 'nginx-restart':
  command => '/etc/init.d/nginx restart',
  path    => '/etc/init.d/',
}
