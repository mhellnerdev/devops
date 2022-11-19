file { "/var/tmp/testfile":
  ensure => "present",
  owner  => "mhellner",
  group  => "mhellner",
  mode   => "0777",
  content => "hello puppet\n",
}
