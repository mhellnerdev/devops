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
