# set timezone. requires mod https://forge.puppet.com/modules/saz/timezone
# puppet module install saz-timezone --version 6.2.0
class { "timezone":
  timezone => "America/New_York",
}

class ntp_class {

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

}

# Declare class in order for it to be applied
include ntp_class
