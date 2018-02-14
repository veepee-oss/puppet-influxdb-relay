# == Class: influxdbrelay::params
#
class influxdbrelay::params {
  # Defaults values.
  $ensure = 'present'
  $service_ensure = 'running'
  $enable = true
  $service = 'influxdb-relay'
  $deps = [
    'git',
    'golang'
  ]
  $gopath = '/opt/go'
  $dirs = [
    '/var/lib/influxdb-relay',
    '/var/log/influxdb-relay',
    '/etc/influxdb-relay'
  ]

  # http params
  $http_name = 'http-relay'
  $http_bind_addr = '127.0.0.1'
  $http_bind_port = '9096'
  $http_ssl = false
  $http_ssl_cert = ''
  $http_outputs = [
    {
      'name'    => 'local1',
      'schema'  => 'http',
      'ip'      => '127.0.0.1',
      'port'    => '8089',
      'timeout' => '10s'
    },
    {
      'name'    => 'local1',
      'schema'  => 'http',
      'ip'      => '127.0.0.1',
      'port'    => '8089',
      'timeout' => '10s'
    }
  ]
  $udp_name = 'udp-relay'
  $udp_bind_addr = '127.0.0.1'
  $udp_bind_port = '9096'
  $udp_readbuffer = 0
  $udp_precision = 'n'
  $udp_outputs = [
    {
      'name' => 'local1',
      'ip'   => '127.0.0.1',
      'port' => '8089',
      'mtu'  => '512'
    },
    {
      'name' => 'local2',
      'ip'   => '127.0.0.1',
      'port' => '7089',
      'mtu'  => '1024'
    }
  ]
}
# EOF
