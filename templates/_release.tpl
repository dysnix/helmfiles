{{/* vim: set filetype=mustache: */}}

{{/* Default release template helper. Renders the default release.

     Note: Paths to values/secrets etc files are normalized to be relative
     to the parent helmfile.
 */}}

{{- $release := .Values._setup.release -}}

{{- range $normalizePathFor := list "set" "setTemplate" "values" "valuesTemplate" "secrets" -}}
  {{- $normalized := list -}}

  {{- range $i, $v := $release | get $normalizePathFor list -}}
    {{- if typeIs "string" $v -}}
      {{- $normalized = append $normalized (printf "../../../%s" $v) -}}
    {{- else if $v -}}
      {{- $normalized = append $normalized $v -}}
    {{- end -}}
  {{- end -}}

  {{- if $normalized -}}
    {{- $release = set $release $normalizePathFor $normalized -}}
  {{- end -}}
{{- end -}}

{{- if $release.valuesTemplate -}}
  {{- $release = set $release "valuesTemplate" (prepend $release.valuesTemplate "values.yaml.gotmpl") -}}
{{- end -}}

{{- $release | toYaml -}}
