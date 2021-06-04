{{/* vim: set filetype=mustache: */}}
{{/*
  Creates issuers lists and validates the input
*/}}

{{- $issuers := list -}}

{{- if .Values | get "_set.letsencrypt.enabled" }}
  {{- if not (hasKey .Values._set.letsencrypt "acme_email") -}}
    {{- fail "\n==> You must specify _set.letsencrypt.acme_email value!" -}}
  {{- end }}
  {{- $issuers = append $issuers "letsencrypt" -}}
{{- end -}}

{{- dict "issuers" $issuers | toYaml }}
