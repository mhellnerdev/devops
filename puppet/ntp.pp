# install puppet timezone module
# mod { 'saz-timezone', '6.2.0' }

# set timezone. requires mod https://forge.puppet.com/modules/saz/timezone
# puppet module install saz-timezone --version 6.2.0
class { "timezone":
  timezone => "America/New_York",
}

# install ntp package
package { "ntp":
  ensure => "present",
}

# setup ntp conf file
file { "/etc/ntp.conf":
  ensure => "present",
  content => "server 0.centos.pool.ntp.org iburst\n",
}

# start ntp services
service { "ntpd":
  ensure => "running",
}
