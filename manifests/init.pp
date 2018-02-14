# == Class: influxdbrelay
#
class influxdbrelay (
  $ensure         = $influxdbrelay::params::ensure,
  $service_ensure = $influxdbrelay::params::service_ensure,
  $service_prvd   = 'systemd',
  $enable         = $influxdbrelay::params::enable,
  $service        = $influxdbrelay::params::service,
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
  package { $deps:
    ensure => $ensure
  }

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
      File['install_relay']
    ]
  }

  file { 'install_relay':
    ensure => 'link',
    path   => '/usr/lib/influxdb-relay',
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
      File['link_binary'],
      File['logrotate']
    ],
    subscribe => File['install_relay'],
    unless    => 'id influxdb-relay'
  }

  file { 'link_binary':
    ensure => 'link',
    path   => '/usr/bin/influxdb-relay',
    target => "${gopath}/bin/influxdb-relay"
  }

  file { 'logrotate':
    ensure => 'link',
    path   => '/etc/logrotate.d/influxdb-relay',
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
