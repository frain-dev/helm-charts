# convoy

![Version: 3.0.0](https://img.shields.io/badge/Version-3.0.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 24.8.2](https://img.shields.io/badge/AppVersion-24.8.2-informational?style=flat-square)

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
| agent.app.replicaCount | int | `1` |  |
| agent.app.resources.limits.cpu | string | `"2000m"` |  |
| agent.app.resources.limits.memory | string | `"2000Mi"` |  |
| agent.app.resources.requests.cpu | string | `"1000m"` |  |
| agent.app.resources.requests.memory | string | `"1000m"` |  |
| agent.autoscaling.enabled | bool | `false` | Enable autoscaling for the agent |
| agent.autoscaling.maxReplicas | int | `10` |  |
| agent.autoscaling.minReplicas | int | `2` |  |
| agent.autoscaling.targetCPUUtilizationPercentage | int | `80` |  |
| agent.autoscaling.targetMemoryUtilizationPercentage | int | `80` |  |
| agent.env.environment | string | `"oss"` |  |
| agent.env.log_level | string | `"error"` |  |
| agent.env.proxy | string | `""` |  |
| agent.env.smtp.enabled | bool | `false` |  |
| agent.env.smtp.from | string | `""` |  |
| agent.env.smtp.password | string | `""` | Ignored in case of secret parameter with non-empty value |
| agent.env.smtp.port | int | `0` |  |
| agent.env.smtp.provider | string | `""` |  |
| agent.env.smtp.secret | string | `""` | If this secret parameter is not empty, password value will be ignored. The password in the secret should be in the 'password' key |
| agent.env.smtp.url | string | `""` |  |
| agent.env.smtp.username | string | `""` |  |
| agent.env.storage.enabled | bool | `false` |  |
| agent.env.storage.on_prem.path | string | `""` |  |
| agent.env.storage.s3.accessKey | string | `""` |  |
| agent.env.storage.s3.bucket | string | `""` |  |
| agent.env.storage.s3.endpoint | string | `""` |  |
| agent.env.storage.s3.region | string | `""` |  |
| agent.env.storage.s3.secret | string | `""` | If this secret parameter is not empty, secretKey value will be ignored. The password in the secret should be in the 'secretKey' key |
| agent.env.storage.s3.secretKey | string | `""` | Ignored in case of secret parameter with non-empty value |
| agent.env.storage.s3.session_token | string | `""` |  |
| agent.env.storage.type | string | `""` |  |
| agent.env.tracer.app_name | string | `""` |  |
| agent.env.tracer.config_enabled | bool | `true` |  |
| agent.env.tracer.distributed_tracer_enabled | bool | `true` |  |
| agent.env.tracer.enabled | bool | `false` |  |
| agent.env.tracer.license_key | string | `""` |  |
| agent.env.tracer.type | string | `""` |  |
| agent.image.pullPolicy | string | `"IfNotPresent"` | Pull policy for the agent image |
| agent.image.repository | string | `"getconvoy/convoy"` | Repository to be used by the agent. The latest tag is used by default |
| agent.podDisruptionBudget | object | `{}` |  |
| agent.service.port | int | `80` | Port for the agent service |
| agent.service.type | string | `"ClusterIP"` | Type of service for the agent |
| global.convoy.environment | string | `"oss"` | Convoy Environment |
| global.convoy.image | string | `"getconvoy/convoy"` | Docker image tags for all convoy services |
| global.convoy.log_level | string | `"error"` | Logger Level for all convoy services |
| global.convoy.tag | string | `"v24.8.2"` | Docker image tags for all convoy services |
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
| global.externalDatabase.secret | string | `""` | If this secret parameter is not empty, password value will be ignored. The password in the secret should be in the 'password' key |
| global.externalDatabase.username | string | `"postgres"` | Username for the external database |
| global.externalRedis.addresses | string | `""` | redis cluster addresses, if set the other values won't be used |
| global.externalRedis.database | string | `""` | Database name for the external redis. |
| global.externalRedis.enabled | bool | `false` | Enable external redis, Enable this if you use an external redis and disable Native redis |
| global.externalRedis.host | string | `""` | Host for the external redis |
| global.externalRedis.password | string | `""` | password for the external redis, ignored in case of secret parameter with non-empty value |
| global.externalRedis.port | string | `""` | Port for the external redis |
| global.externalRedis.scheme | string | `""` | Scheme for the external redis. This can be redis, rediss, redis-socket or redis-sentinel |
| global.externalRedis.secret | string | `""` | If this secret parameter is not empty, password value will be ignored. The password in the secret should be in the 'password' key |
| global.externalRedis.username | string | `""` | username for the external redis. |
| global.nativeRedis.enabled | bool | `true` | Enable redis, This will use redis chart, Disable if you use an external redis |
| global.nativeRedis.host | string | `"redis-master"` | Host for the redis |
| global.nativeRedis.password | string | `"convoy"` | password for the redis, ignored in case of secret parameter with non-empty value |
| global.nativeRedis.port | int | `6379` | Port for the redis |
| global.nativeRedis.secret | string | `""` | If this secret parameter is not empty, password value will be ignored. The password in the secret should be in the 'password' key |
| server.app.replicaCount | int | `1` |  |
| server.app.resources.limits.cpu | string | `"2000m"` |  |
| server.app.resources.limits.memory | string | `"2000Mi"` |  |
| server.app.resources.requests.cpu | string | `"1000m"` |  |
| server.app.resources.requests.memory | string | `"1000Mi"` |  |
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
| server.env.max_response_size | int | `50` | Max response body when ingesting webhooks (might be renamed). Defaults to 50KB |
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
| server.image.repository | string | `"getconvoy/convoy"` | Repository to be used by the server. The latest tag is used by default |
| server.ingress.annotations | object | `{}` |  |
| server.ingress.enabled | bool | `false` | Enable ingress for the server |
| server.ingress.hosts[0].host | string | `"test.com"` |  |
| server.ingress.hosts[0].http.paths[0].path | string | `"/"` |  |
| server.ingress.hosts[0].http.paths[0].pathType | string | `"Prefix"` |  |
| server.ingress.ingressClassName | string | `""` |  |
| server.ingress.tls[0].hosts[0] | string | `"test.com"` |  |
| server.ingress.tls[0].secretName | string | `"test-tls-secret"` |  |
| server.podDisruptionBudget | object | `{}` |  |
| server.service.port | int | `80` | Port for the server service |
| server.service.type | string | `"ClusterIP"` | Type of service for the server |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.11.0](https://github.com/norwoodj/helm-docs/releases/v1.11.0)
