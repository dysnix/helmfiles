{{/* vim: set filetype=mustache: */}}
{{/*
Example:

  affinity:
    podAntiAffinity: {{- tpl (readFile "../../templates/pod-affinities.tpl") (dict "type" "podAntiAffinity" context $) | nindent 6 }}

*/}}
{{- $values := .context.Values -}}
{{- $affinity := $values | get (list "_set" .type "enabled" | join ".") "false" | toString -}}

{{- if $values | get (list "_set" .type | join ".") "" -}}
  {{- if has $affinity (list "true" "soft") -}}
preferredDuringSchedulingIgnoredDuringExecution:
- weight: {{ $values._set | get (list .type "weight" | join ".") }}
  podAffinityTerm:
    labelSelector:
      matchExpressions: {{- $values | get (list "_default" .type "matchExpressions" | join ".") | toYaml | nindent 8 }}
    topologyKey: {{ $values | get (list "_default" .type "topologyKey" | join ".") }}
  {{- else if eq $affinity "hard" }}
requiredDuringSchedulingIgnoredDuringExecution:
- labelSelector:
    matchExpressions: {{- $values | get (list "_default" .type "matchExpressions" | join ".") | toYaml | nindent 6 }}
  topologyKey: {{ $values | get (list "_default" .type "topologyKey" | join ".") }}
  {{- end }}
{{- else -}}
  {{- dict | toYaml }}
{{- end }}
