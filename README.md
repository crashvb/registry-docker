# registry-docker

## Overview

This docker image contains a docker [registry](https://docs.docker.com/registry/).

## Entrypoint Scripts

### registry

The embedded entrypoint script is located at `/etc/entrypoint.d/registry` and performs the following actions:

1. A new registry configuration is generated using the following environment variables:

 | Variable | Default Value | Description |
 | ---------| ------------- | ----------- |
 | REGISTRY_PASSWORD | _random_ | The checksum of the registry webserver password. |

## Standard Configuration

### Container Layout

```
/
├─ bin/
│  └─ registry
├─ etc/
│  ├─ docker/
│  │  └─ registry/
│  │     └─ config.yml
│  └─ entrypoint.d/
│     └─ registry
├─ root/
│  └─ registry_password
└─ var/
   └─ lib/
      └─ registry/
          └─ .htpasswd
```

### Exposed Ports

* `5000/tcp` - Docker registry port.

### Volumes

* `/var/lib/registry` - The registry data location.

## Development

[Source Control](https://github.com/crashvb/registry-docker)

