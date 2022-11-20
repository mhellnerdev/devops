# set timezone. requires mod https://forge.puppet.com/modules/saz/timezone
# puppet module install saz-timezone --version 6.2.0
class { "timezone":
  timezone => "America/Los_Angeles",
}
