# convoy

Open Source Webhooks Gateway

![Version: 1.0.0](https://img.shields.io/badge/Version-1.0.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 0.9.2](https://img.shields.io/badge/AppVersion-0.9.2-informational?style=flat-square)

### `Homepage`:

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| Convoy Engineering Team | <engineering@getconvoy.io> | <https://getconvoy.io> |
| Obinna Odirionye | <odirionye@gmail.com> | <https://iamobinna.com> |

## Requirements

| Repository | Name | Version |
|------------|------|---------|
| https://charts.bitnami.com/bitnami | postgresql | 12.2.7 |
| https://charts.bitnami.com/bitnami | redis | 17.9.3 |

## Installation
```bash
helm dependency update # this is update the helm dependencies
helm upgrade convoy ./ --install --namespace convoy --create-namespace
```

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| global.externalDatabase.database | string | `"convoy?sslmode=disable"` | Database name for the external database |
| global.externalDatabase.enabled | bool | `true` | Enable external database, This will use postgresql chart, Change values if you use an external database |
| global.externalDatabase.host | string | `"postgresql"` | Host for the external database |
| global.externalDatabase.password | string | `"postgres"` | Username for the external database |
| global.externalDatabase.port | int | `5432` | Port for the external database |
| global.externalDatabase.postgresPassword | string | `"postgres"` | Password for the external database |
| global.externalDatabase.scheme | string | `"postgres"` | scheme for the external database. This is postgres by default |
| global.externalDatabase.username | string | `"postgres"` | Username for the external database |
| global.externalRedis.database | string | `""` | Database name for the external redis. |
| global.externalRedis.enabled | bool | `false` | Enable external redis, Enable this if you use an external redis and disable Native redis |
| global.externalRedis.host | string | `""` | Host for the external redis |
| global.externalRedis.password | string | `""` | password for the external redis. |
| global.externalRedis.port | string | `""` | Port for the external redis |
| global.externalRedis.scheme | string | `""` | scheme for the external redis. This can be redis or rediss |
| global.externalRedis.username | string | `""` | username for the external redis. |
| global.nativeRedis.enabled | bool | `true` | Enable redis, This will use redis chart, Disable if you use an external redis |
| global.nativeRedis.host | string | `"redis-master"` | Host for the redis |
| global.nativeRedis.password | string | `"convoy"` | password for the redis. |
| migrate.image.pullPolicy | string | `"IfNotPresent"` | Pull policy for the migrate image |
| migrate.image.repository | string | `"rtukpe/convoy-helm-test"` | Repository to be used by to migrate. Latest tag is used by default. it will install before any other services. |
| migrate.image.tag | string | `"v1"` | Tag for the migrate image |
| scheduler.image.pullPolicy | string | `"IfNotPresent"` | Pull policy for the scheduler image |
| scheduler.image.repository | string | `"rtukpe/convoy-helm-test"` | Repository to be used by the scheduler. Latest tag is used by default |
| scheduler.image.tag | string | `"v1"` | Tag for the scheduler image |
| server.autoscaling.enabled | bool | `false` | Enable autoscaling for the server |
| server.image.pullPolicy | string | `"IfNotPresent"` | Pull policy for the server image |
| server.image.repository | string | `"rtukpe/convoy-helm-test"` | Repository to be used by the server. Latest tag is used by default |
| server.image.tag | string | `"v1"` | Tag for the server image |
| server.ingress.enabled | bool | `false` | Enable ingress for the server |
| server.service.port | int | `80` | Port for the server service |
| server.service.type | string | `"ClusterIP"` | Type of service for the server |
| stream.autoscaling.enabled | bool | `false` | Enable autoscaling for the stream |
| stream.image.pullPolicy | string | `"IfNotPresent"` | Pull policy for the stream image |
| stream.image.repository | string | `"rtukpe/convoy-helm-test"` | Repository to be used by the stream. Latest tag is used by default |
| stream.image.tag | string | `"v1"` | Tag for the stream image |
| stream.ingress.enabled | bool | `false` | Enable ingress for the stream |
| stream.service.port | int | `80` | Port for the stream service |
| stream.service.type | string | `"ClusterIP"` | Type of service for the stream |
| worker.autoscaling.enabled | bool | `false` | Enable autoscaling for the worker |
| worker.image.pullPolicy | string | `"IfNotPresent"` | Pull policy for the worker image |
| worker.image.repository | string | `"rtukpe/convoy-helm-test"` | Repository to be used by the worker. Latest tag is used by default |
| worker.image.tag | string | `"v1"` | Tag for the worker image |
| worker.ingress.enabled | bool | `false` | Enable ingress for the worker |
| worker.postgres.enabled | bool | `true` | Enable postgresql for the worker |
| worker.service.port | int | `80` | Port for the worker service |
| worker.service.type | string | `"ClusterIP"` | Type of service for the worker |

## Uninstalling

```bash
helm delete convoy -n convoy
```
