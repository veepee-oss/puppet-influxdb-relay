# -*- puppet -*-

exec { 'apt-get update':
  command => 'apt-get update -qq',
  path    => [ '/usr/bin', '/usr/sbin', '/bin', '/sbin' ],
}

if $lsbdistcodename == 'jessie' {
  class { 'influxdbrelay':
    require   => Exec[ 'apt-get update' ],
    backports => 'jessie-backports'
  }
} else {
  class { 'influxdbrelay':
    require => Exec[ 'apt-get update' ]
  }
}
# EOF
