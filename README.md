# registry-docker

[![version)](https://img.shields.io/docker/v/crashvb/registry/latest)](https://hub.docker.com/repository/docker/crashvb/registry)
[![image size](https://img.shields.io/docker/image-size/crashvb/registry/latest)](https://hub.docker.com/repository/docker/crashvb/registry)
[![linting](https://img.shields.io/badge/linting-hadolint-yellow)](https://github.com/hadolint/hadolint)
[![license](https://img.shields.io/github/license/crashvb/registry-docker.svg)](https://github.com/crashvb/registry-docker/blob/master/LICENSE.md)

## Overview

This docker image contains a docker [registry](https://docs.docker.com/registry/).

## Entrypoint Scripts

### registry

The embedded entrypoint script is located at `/etc/entrypoint.d/registry` and performs the following actions:

1. The PKI certificates are generated or imported.
2. A new registry configuration is generated using the following environment variables:

 | Variable | Default Value | Description |
 | -------- | ------------- | ----------- |
 | REGISTRY\_CERT\_DAYS | 30 | Validity period of any generated PKI certificates. |
 | REGISTRY\_KEY\_SIZE | 4096 | Key size of any generated PKI keys. |
 | REGISTRY\_USERS | admin | The list of users to be allowed access. |

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
├─ run/
│  └─ secrets/
│     ├─ registry.crt
│     ├─ registry.key
│     ├─ registryca.crt
│     └─ registry_<user>_password
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

## See Also
* [Configuring a registry](https://docs.docker.com/registry/configuration/)

