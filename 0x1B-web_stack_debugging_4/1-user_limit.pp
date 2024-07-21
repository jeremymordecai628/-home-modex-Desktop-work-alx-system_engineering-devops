# Increase the ULIMIT of the default file
exec { 'fix--for-nginx':
  command => '/bin/sed -i "s/15/4096/" /etc/default/nginx',
  path    => '/usr/local/bin/:/bin/',
}

# Reload Nginx to apply configuration changes
exec { 'nginx-reload':
  command     => 'nginx -s reload',
  path        => ['/usr/bin', '/usr/sbin'],
  refreshonly => true,
}

# Ensure the Holberton user exists
user { 'holberton':
  ensure     => present,
  managehome => true,
  home       => '/home/holberton',
  shell      => '/bin/bash',
}

# Increase hard file limit for Holberton user
exec { 'increase-hard-file-limit-for-holberton-user':
  command => "sed -i '/^holberton hard/s/5/50000/' /etc/security/limits.conf",
  path    => '/usr/local/bin/:/bin/',
  unless  => 'grep -q "^holberton hard .* 50000" /etc/security/limits.conf',
}

# Increase soft file limit for Holberton user
exec { 'increase-soft-file-limit-for-holberton-user':
  command => 'sed -i "/^holberton soft/s/4/50000/" /etc/security/limits.conf',
  path    => '/usr/local/bin/:/bin/',
  unless  => 'grep -q "^holberton soft .* 50000" /etc/security/limits.conf',
}

# Ensure the home directory of the Holberton user is accessible
file { '/home/holberton':
  ensure => directory,
  owner  => 'holberton',
  group  => 'holberton',
  mode   => '0755',
}

# Ensure the Holberton user can open files in their home directory
file { '/home/holberton/testfile':
  ensure  => present,
  owner   => 'holberton',
  group   => 'holberton',
  mode    => '0644',
  content => 'This is a test file for Holberton user.',
}
