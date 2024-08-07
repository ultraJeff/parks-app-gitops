{{/*
Expand the name of the chart.
*/}}
{{- define "parks-app.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "parks-app.fullname" -}}
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
Common labels
*/}}
{{- define "parks-app.labels" -}}
{{ .Values.podLabels }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "parks-app.selectorLabels" -}}
app.kubernetes.io/name: {{ include "parks-app.name" . }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "parks-app.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "parks-app.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}
