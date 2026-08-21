{{/*
Expand the name of the chart.
*/}}
{{- define "convoy-server.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "convoy-server.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "convoy-server.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "convoy-server.labels" -}}
helm.sh/chart: {{ include "convoy-server.chart" . }}
{{ include "convoy-server.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "convoy-server.selectorLabels" -}}
app.kubernetes.io/name: {{ include "convoy-server.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "convoy-server.jwtSecretName" -}}
{{- if .Values.global.convoy.jwt_secret_name -}}
{{- .Values.global.convoy.jwt_secret_name -}}
{{- else -}}
{{- include "convoy-server.fullname" . }}-jwt
{{- end -}}
{{- end }}

{{/*
Queue provider and Postgres queue tuning env vars.

Convoy refuses to boot with the Postgres queue unless the postgres-queue
feature flag is set, so rendering that provider without the flag would only
produce a crash loop. Fail here instead, where the message can name the value
to set. The paid license the provider also needs cannot be checked from a chart.
*/}}
{{- define "convoy-server.queueProviderEnv" -}}
{{- $provider := .Values.global.convoy.queue_provider | default "redis" -}}
{{- if eq $provider "postgres" -}}
{{- if not (has "postgres-queue" (.Values.env.enable_feature_flag | default list)) -}}
{{- fail "global.convoy.queue_provider is \"postgres\" but server.env.enable_feature_flag does not include \"postgres-queue\". Convoy refuses to boot with the Postgres queue unless that feature flag is set, and the provider also needs a paid license that includes it. Set the flag on the agent too." -}}
{{- end -}}
{{- end -}}
- name: CONVOY_QUEUE_PROVIDER
  value: {{ $provider | quote }}
{{- if eq $provider "postgres" }}
{{- with .Values.global.convoy.postgresQueue }}
- name: CONVOY_POSTGRES_QUEUE_BATCH_SIZE
  value: {{ .batchSize | default 64 | quote }}
- name: CONVOY_POSTGRES_QUEUE_BATCH_WAIT_MS
  value: {{ .batchWaitMs | default 2 | quote }}
- name: CONVOY_POSTGRES_QUEUE_WRITE_CONCURRENCY
  value: {{ .writeConcurrency | default 8 | quote }}
- name: CONVOY_POSTGRES_QUEUE_LEASE_TIMEOUT_SECONDS
  value: {{ .leaseTimeoutSeconds | default 90 | quote }}
- name: CONVOY_POSTGRES_QUEUE_CLAIM_BATCH_SIZE
  value: {{ .claimBatchSize | default 64 | quote }}
- name: CONVOY_POSTGRES_QUEUE_POLL_IDLE_MS
  value: {{ .pollIdleMs | default 5 | quote }}
- name: CONVOY_POSTGRES_CACHE_LOCAL_READ_TTL_MS
  value: {{ .cacheLocalReadTtlMs | default 1000 | quote }}
- name: CONVOY_POSTGRES_CACHE_LOCAL_READ_SIZE
  value: {{ .cacheLocalReadSize | default 10000 | quote }}
{{- end }}
{{- end }}
{{- end }}
