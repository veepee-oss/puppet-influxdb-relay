# puppet-influxdbrelay ![License][license-img]

1. [Overview](#overview)
2. [Description](#module-description)
3. [Setup](#setup)
4. [Usage](#usage)
5. [Limitations](#limitations)
6. [Development](#development)
7. [Miscellaneous](#miscellaneous)

## Overview

This project adds a basic high availability layer to InfluxDB.
With the right architecture  and  disaster recovery processes,  this achieves a
highly available setup.

[github.com/influxdata]
(https://github.com/influxdata/influxdb-relay#description)

## Description

This module enables you to install, deploy, and configure influxdbrelay.

## Setup

Copy this module in your modules folder without *puppet-* in the name.

## Usage

Use default configuration.

```puppet
class { 'influxdbrelay': }
```

Add your configuration.

```puppet
class { 'influxdbrelay':
  http_bind_addr => '192.168.1.18',
  http_bind_port => '9089',
  http_outputs   => [
    {
      'name'    => 'localhttp',
      'schema'  => 'http',
      'ip'      => '127.0.0.1',
      'port'    => '8089',
      'timeout' => '60s'
    },
    {
      'name'    => 'remotehttp',
      'schema'  => 'http',
      'ip'      => '192.168.1.19',
      'port'    => '8089',
      'timeout' => '60s'
    }
  ]
}
```

## Limitations

influxdb-relay requires golang version 1.5 or newer.

## Development

Please read carefully [CONTRIBUTING.md]
(https://git.vpgrp.io/ansible/puppet-rules/raw/master/CONTRIBUTING.md)
before making a merge request.

```
    ╚⊙ ⊙╝
  ╚═(███)═╝
 ╚═(███)═╝
╚═(███)═╝
 ╚═(███)═╝
  ╚═(███)═╝
   ╚═(███)═╝
```

[license-img]: https://img.shields.io/badge/license-Apache-blue.svg
