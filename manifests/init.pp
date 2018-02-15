# == Class: influxdbrelay
#
class influxdbrelay (
  $ensure         = $influxdbrelay::params::ensure,
  $service_ensure = $influxdbrelay::params::service_ensure,
  $service_prvd   = 'systemd',
  $enable         = $influxdbrelay::params::enable,
  $service        = $influxdbrelay::params::service,
  $backports      = '',
  $deps           = $influxdbrelay::params::deps,
  $gopath         = $influxdbrelay::params::gopath,
  $dirs           = $influxdbrelay::params::dirs,
  $http_name      = $influxdbrelay::params::http_name,
  $http_bind_addr = $influxdbrelay::params::http_bind_addr,
  $http_bind_port = $influxdbrelay::params::http_bind_port,
  $http_ssl       = $influxdbrelay::params::http_ssl,
  $http_ssl_cert  = $influxdbrelay::params::http_ssl_cert,
  $http_outputs   = $influxdbrelay::params::http_outputs,
  $udp_name       = $influxdbrelay::params::udp_name,
  $udp_bind_addr  = $influxdbrelay::params::udp_bind_addr,
  $udp_bind_port  = $influxdbrelay::params::udp_bind_port,
  $udp_readbuffer = $influxdbrelay::params::udp_readbuffer,
  $udp_precision  = $influxdbrelay::params::udp_precision,
  $udp_outputs    = $influxdbrelay::params::udp_outputs
) inherits influxdbrelay::params {

  # Dependencies management.
  if $backports != '' {
    package { $deps:
      ensure          => $ensure,
      install_options => [ '-t', $backports ]
    }
  } else {
    package { $deps:
      ensure  => $ensure
    }
  }

  Package <| |> -> Exec['go_get_relay']

  file { 'gopath':
    ensure => 'directory',
    path   => $gopath,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
    notify => File['/etc/environment']
  }

  file { $dirs:
    ensure => 'directory',
    mode   => '0755'
  }

  file { '/etc/environment':
    content => inline_template("GOPATH=${gopath}"),
    notify  => [
      Exec['go_get_relay'],
      File['/usr/lib/influxdb-relay']
    ]
  }

  file { '/usr/lib/influxdb-relay':
    ensure => 'link',
    target => "${gopath}/src/github.com/influxdata/influxdb-relay/",
    notify => File['/etc/influxdb-relay/influxdb-relay.conf']
  }

  exec { 'go_get_relay':
    path        =>
      '/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin',
    environment => "GOPATH=${gopath}",
    command     => 'go get -u github.com/influxdata/influxdb-relay',
    notify      => Exec['post-install'],
    unless      => "test -d ${gopath}/src/github.com/influxdata/influxdb-relay"
  }

  exec { 'post-install':
    path      =>
      '/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin',
    command   => 'bash /usr/lib/influxdb-relay/scripts/post-install.sh',
    notify    => [
      File['/usr/bin/influxdb-relay'],
      File['/etc/logrotate.d/influxdb-relay']
    ],
    subscribe => File['/usr/lib/influxdb-relay'],
    unless    => 'id influxdb-relay'
  }

  file { '/usr/bin/influxdb-relay':
    ensure => 'link',
    target => "${gopath}/bin/influxdb-relay"
  }

  file { '/etc/logrotate.d/influxdb-relay':
    ensure => 'link',
    target =>
      "${gopath}/src/github.com/influxdata/influxdb-relay/scripts/logrotate"
  }

  file { '/etc/influxdb-relay/influxdb-relay.conf':
    ensure  => $ensure,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('influxdbrelay/influxdb-relay.conf.erb'),
    notify  => Service[$service],
  }

  service { $service:
    ensure   => $service_ensure,
    enable   => $enable,
    provider => $service_prvd
  }
}
