# -*- puppet -*-

exec { 'apt-get update':
  command => 'apt-get update -qq',
  path    => [ '/usr/bin', '/usr/sbin', '/bin', '/sbin' ],
}

class { 'influxdbrelay':
  require => Exec[ 'apt-get update' ]
}
# EOF
