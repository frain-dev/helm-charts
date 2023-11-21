# convoy

![Version: 2.0.0](https://img.shields.io/badge/Version-2.0.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 23.11.1](https://img.shields.io/badge/AppVersion-23.11.1-informational?style=flat-square)

Open Source Webhooks Gateway

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| Convoy Engineering Team | <engineering@getconvoy.io> | <https://getconvoy.io> |

## Requirements

| Repository | Name | Version |
|------------|------|---------|
| https://charts.bitnami.com/bitnami | postgresql | 12.5.6 |
| https://charts.bitnami.com/bitnami | redis | 17.11.3 |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| global.convoy.environment | string | `"oss"` | Convoy Environment |
| global.convoy.image | string | `"docker.cloudsmith.io/convoy/convoy/frain-dev/convoy"` | Docker image tags for all convoy services |
| global.convoy.log_level | string | `"error"` | Logger Level for all convoy services |
| global.convoy.tag | string | `"v23.11.1"` | Docker image tags for all convoy services |
| global.convoy.tracer_app_name | string | `""` | NewRelic application name |
| global.convoy.tracer_config_enabled | bool | `true` | NewRelic tracing config enabled |
| global.convoy.tracer_distributed_tracer_enabled | bool | `true` | NewRelic distributed tracing config enabled |
| global.convoy.tracer_enabled | bool | `false` | Tracing config for all convoy services |
| global.convoy.tracer_license_key | string | `""` | NewRelic license key |
| global.convoy.tracer_type | string | `""` | Tracing provider type |
| global.externalDatabase.database | string | `"convoy"` | Database name for the external database |
| global.externalDatabase.enabled | bool | `true` | Enable an external database, This will use postgresql chart, Change values if you use an external database |
| global.externalDatabase.host | string | `"postgresql"` | Host for the external database |
| global.externalDatabase.options | string | `"sslmode=disable&connect_timeout=30"` | Query params for the external database |
| global.externalDatabase.password | string | `"postgres"` | Password for the external database, ignored in case of secret parameter with non-empty value |
| global.externalDatabase.port | int | `5432` | Port for the external database |
| global.externalDatabase.postgresPassword | string | `"postgres"` | Password for the external database |
| global.externalDatabase.scheme | string | `"postgres"` | scheme for the external database. This is postgres by default |
| global.externalDatabase.secret | string | `""` | If this secret parameter is not empty, password value will be ignored. The password in the secret should be in the 'password' key |
| global.externalDatabase.username | string | `"postgres"` | Username for the external database |
| global.externalRedis.addresses | string | `""` | redis cluster addresses, if set the other values won't be used |
| global.externalRedis.database | string | `""` | Database name for the external redis. |
| global.externalRedis.enabled | bool | `false` | Enable external redis, Enable this if you use an external redis and disable Native redis |
| global.externalRedis.host | string | `""` | Host for the external redis |
| global.externalRedis.password | string | `""` | password for the external redis, ignored in case of secret parameter with non-empty value |
| global.externalRedis.port | string | `""` | Port for the external redis |
| global.externalRedis.scheme | string | `""` | scheme for the external redis. This can be redis, rediss, redis-socket or redis-sentinel |
| global.externalRedis.secret | string | `""` | If this secret parameter is not empty, password value will be ignored. The password in the secret should be in the 'password' key |
| global.externalRedis.username | string | `""` | username for the external redis. |
| global.nativeRedis.enabled | bool | `true` | Enable redis, This will use redis chart, Disable if you use an external redis |
| global.nativeRedis.host | string | `"redis-master"` | Host for the redis |
| global.nativeRedis.password | string | `"convoy"` | password for the redis, ignored in case of secret parameter with non-empty value |
| global.nativeRedis.port | int | `6379` | Port for the redis |
| global.nativeRedis.secret | string | `""` | If this secret parameter is not empty, password value will be ignored. The password in the secret should be in the 'password' key |
| ingest.app.resources.limits.cpu | string | `"60m"` |  |
| ingest.app.resources.limits.memory | string | `"60Mi"` |  |
| ingest.app.resources.requests.cpu | string | `"50m"` |  |
| ingest.app.resources.requests.memory | string | `"50Mi"` |  |
| ingest.autoscaling.enabled | bool | `false` | Enable autoscaling for the worker |
| ingest.autoscaling.maxReplicas | int | `10` |  |
| ingest.autoscaling.minReplicas | int | `1` |  |
| ingest.autoscaling.targetCPUUtilizationPercentage | int | `80` |  |
| ingest.autoscaling.targetMemoryUtilizationPercentage | int | `80` |  |
| ingest.enabled | bool | `false` |  |
| ingest.env.environment | string | `"oss"` |  |
| ingest.env.interval | int | `60` |  |
| ingest.env.log_level | string | `"error"` |  |
| ingest.image.pullPolicy | string | `"IfNotPresent"` | Pull policy for the worker image |
| ingest.image.repository | string | `"docker.cloudsmith.io/convoy/convoy/frain-dev/convoy"` | Repository to be used by the worker. Latest tag is used by default |
| ingest.service.port | int | `80` | Port for the worker service |
| ingest.service.type | string | `"ClusterIP"` | Type of service for the worker |
| migrate.image.pullPolicy | string | `"IfNotPresent"` | Pull policy for the migrate image |
| migrate.image.repository | string | `"docker.cloudsmith.io/convoy/convoy/frain-dev/convoy"` | Repository to be used by to migrate. The latest tag is used by default. it will install before any other services. |
| server.app.port | int | `5005` |  |
| server.app.resources.limits.cpu | string | `"50m"` |  |
| server.app.resources.limits.memory | string | `"60Mi"` |  |
| server.app.resources.requests.cpu | string | `"40m"` |  |
| server.app.resources.requests.memory | string | `"50Mi"` |  |
| server.autoscaling.enabled | bool | `false` | Enable autoscaling for the server |
| server.autoscaling.maxReplicas | int | `10` |  |
| server.autoscaling.minReplicas | int | `2` |  |
| server.autoscaling.targetCPUUtilizationPercentage | int | `80` |  |
| server.autoscaling.targetMemoryUtilizationPercentage | int | `80` |  |
| server.env.auth.jwt.enabled | bool | `true` |  |
| server.env.auth.native.enabled | bool | `true` |  |
| server.env.environment | string | `"oss"` |  |
| server.env.host | string | `""` |  |
| server.env.log_level | string | `"error"` |  |
| server.env.sign_up_enabled | bool | `false` |  |
| server.env.storage.enabled | bool | `false` |  |
| server.env.storage.on_prem.path | string | `""` |  |
| server.env.storage.s3.accessKey | string | `""` |  |
| server.env.storage.s3.bucket | string | `""` |  |
| server.env.storage.s3.endpoint | string | `""` |  |
| server.env.storage.s3.region | string | `""` |  |
| server.env.storage.s3.secret | string | `""` | If this secret parameter is not empty, secretKey value will be ignored. The password in the secret should be in the 'secretKey' key |
| server.env.storage.s3.secretKey | string | `""` | Ignored in case of secret parameter with non-empty value |
| server.env.storage.s3.session_token | string | `""` |  |
| server.env.storage.type | string | `""` |  |
| server.image.pullPolicy | string | `"IfNotPresent"` | Pull policy for the server image |
| server.image.repository | string | `"docker.cloudsmith.io/convoy/convoy/frain-dev/convoy"` | Repository to be used by the server. Latest tag is used by default |
| server.ingress.annotations | list | `[]` |  |
| server.ingress.enabled | bool | `false` | Enable ingress for the server |
| server.ingress.hosts[0].host | string | `"test.com"` |  |
| server.ingress.hosts[0].http.paths[0].path | string | `"/"` |  |
| server.ingress.hosts[0].http.paths[0].pathType | string | `"Prefix"` |  |
| server.ingress.ingressClassName | string | `""` |  |
| server.ingress.tls[0].hosts[0] | string | `"test.com"` |  |
| server.ingress.tls[0].secretName | string | `"test-tls-secret"` |  |
| server.service.port | int | `80` | Port for the server service |
| server.service.type | string | `"ClusterIP"` | Type of service for the server |
| stream.app.port | int | `5008` |  |
| stream.app.resources.limits.cpu | string | `"50m"` |  |
| stream.app.resources.limits.memory | string | `"60Mi"` |  |
| stream.app.resources.requests.cpu | string | `"40m"` |  |
| stream.app.resources.requests.memory | string | `"50Mi"` |  |
| stream.autoscaling.enabled | bool | `false` | Enable autoscaling for the stream |
| stream.autoscaling.maxReplicas | int | `10` |  |
| stream.autoscaling.minReplicas | int | `1` |  |
| stream.autoscaling.targetCPUUtilizationPercentage | int | `80` |  |
| stream.autoscaling.targetMemoryUtilizationPercentage | int | `80` |  |
| stream.enabled | bool | `false` |  |
| stream.env.environment | string | `"oss"` |  |
| stream.image.pullPolicy | string | `"IfNotPresent"` | Pull policy for the stream image |
| stream.image.repository | string | `"docker.cloudsmith.io/convoy/convoy/frain-dev/convoy"` | Repository to be used by the stream. Latest tag is used by default |
| stream.ingress.annotations | list | `[]` |  |
| stream.ingress.enabled | bool | `false` | Enable ingress for the stream server |
| stream.ingress.hosts[0].host | string | `"stream.test.com"` |  |
| stream.ingress.hosts[0].http.paths[0].path | string | `"/"` |  |
| stream.ingress.hosts[0].http.paths[0].pathType | string | `"Prefix"` |  |
| stream.ingress.ingressClassName | string | `""` |  |
| stream.ingress.tls[0].hosts[0] | string | `"stream.test.com"` |  |
| stream.ingress.tls[0].secretName | string | `"test-tls-secret"` |  |
| stream.service.port | int | `80` | Port for the stream service |
| stream.service.type | string | `"ClusterIP"` | Type of service for the stream |
| worker.app.resources.limits.cpu | string | `"50m"` |  |
| worker.app.resources.limits.memory | string | `"20Mi"` |  |
| worker.app.resources.requests.cpu | string | `"50m"` |  |
| worker.app.resources.requests.memory | string | `"10Mi"` |  |
| worker.autoscaling.enabled | bool | `false` | Enable autoscaling for the worker |
| worker.autoscaling.maxReplicas | int | `10` |  |
| worker.autoscaling.minReplicas | int | `2` |  |
| worker.autoscaling.targetCPUUtilizationPercentage | int | `80` |  |
| worker.autoscaling.targetMemoryUtilizationPercentage | int | `80` |  |
| worker.env.environment | string | `"oss"` |  |
| worker.env.log_level | string | `"error"` |  |
| worker.env.proxy | string | `""` |  |
| worker.env.smtp.enabled | bool | `false` |  |
| worker.env.smtp.from | string | `""` |  |
| worker.env.smtp.password | string | `""` | Ignored in case of secret parameter with non-empty value |
| worker.env.smtp.port | int | `0` |  |
| worker.env.smtp.provider | string | `""` |  |
| worker.env.smtp.secret | string | `""` | If this secret parameter is not empty, password value will be ignored. The password in the secret should be in the 'password' key |
| worker.env.smtp.url | string | `""` |  |
| worker.env.smtp.username | string | `""` |  |
| worker.env.storage.enabled | bool | `false` |  |
| worker.env.storage.on_prem.path | string | `""` |  |
| worker.env.storage.s3.accessKey | string | `""` |  |
| worker.env.storage.s3.bucket | string | `""` |  |
| worker.env.storage.s3.endpoint | string | `""` |  |
| worker.env.storage.s3.region | string | `""` |  |
| worker.env.storage.s3.secret | string | `""` | If this secret parameter is not empty, secretKey value will be ignored. The password in the secret should be in the 'secretKey' key |
| worker.env.storage.s3.secretKey | string | `""` | Ignored in case of secret parameter with non-empty value |
| worker.env.storage.s3.session_token | string | `""` |  |
| worker.env.storage.type | string | `""` |  |
| worker.env.tracer.app_name | string | `""` |  |
| worker.env.tracer.config_enabled | bool | `true` |  |
| worker.env.tracer.distributed_tracer_enabled | bool | `true` |  |
| worker.env.tracer.enabled | bool | `false` |  |
| worker.env.tracer.license_key | string | `""` |  |
| worker.env.tracer.type | string | `""` |  |
| worker.image.pullPolicy | string | `"IfNotPresent"` | Pull policy for the worker image |
| worker.image.repository | string | `"docker.cloudsmith.io/convoy/convoy/frain-dev/convoy"` | Repository to be used by the worker. Latest tag is used by default |
| worker.service.port | int | `80` | Port for the worker service |
| worker.service.type | string | `"ClusterIP"` | Type of service for the worker |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.11.0](https://github.com/norwoodj/helm-docs/releases/v1.11.0)
