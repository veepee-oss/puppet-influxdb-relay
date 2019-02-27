# == Class: influxdbrelay::params
#
class influxdbrelay::params {
  # Defaults values.
  $ensure         = 'present'
  $service_ensure = 'running'
  $enable         = true
  $service        = 'influxdb-relay'
  $deps           = [
    'git',
    'golang'
  ]
  $gopath         = '/opt/go'
  $dirs           = [
    '/var/lib/influxdb-relay',
    '/var/log/influxdb-relay',
    '/etc/influxdb-relay'
  ]

  # http params
  $http_name              = 'http-relay'
  $http_bind_addr         = '127.0.0.1'
  $http_bind_port         = '9096'
  $http_health_timeout_ms = '2000'
  $http_ssl               = false
  $http_ssl_cert          = ''
  $http_outputs           = [
    {
      'name'       => 'local1',
      'schema'     => 'http',
      'host'       => '127.0.0.1',
      'port'       => '8086',
      'timeout'    => '10s',
      'write'      => '/write',
      'write_prom' => '/write_prom',
      'ping'       => '/ping',
      'query'      => '/query'
    },
    {
      'name'       => 'local2',
      'schema'     => 'http',
      'host'       => '127.0.0.1',
      'port'       => '8086',
      'timeout'    => '10s',
      'write'      => '/write',
      'write_prom' => '/write_prom',
      'ping'       => '/ping',
      'query'      => '/query'
    }
  ]
  $udp_name       = 'udp-relay'
  $udp_bind_addr  = '127.0.0.1'
  $udp_bind_port  = '9096'
  $udp_readbuffer = 0
  $udp_precision  = 'n'
  $udp_outputs    = [
    {
      'name' => 'local1',
      'host' => '127.0.0.1',
      'port' => '8089',
      'mtu'  => '512'
    },
    {
      'name' => 'local2',
      'host' => '127.0.0.1',
      'port' => '7089',
      'mtu'  => '1024'
    }
  ]
}
# EOF
