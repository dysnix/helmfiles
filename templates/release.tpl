{{/* vim: set filetype=mustache: */}}
{{/*
Default release template helper. Renders the default release. It's common for all releases.

Pass opts and context to render the release template. opts dict may contain additional data
which will be used during rendering (ex. hooks). context - is the rendering context.
Usage example:

{{- $hooks := tpl (readFile "templates/release-hooks.tpl") . | fromYaml | default dict | get "hooks" list -}}
{{- $release := tpl (readFile "../../templates/release.tpl") (dict "opts" (dict "hooks" $hooks) "context" $) -}}
releases:
- {{- $release | nindent 2 -}}


Note: Paths to values/secrets etc files are normalized to be relative to the parent helmfile!
*/}}

{{- $release := .context.Values._use.release -}}
{{- $opts := . | get "opts" dict -}}

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

{{/* Inject the default values.yaml.gotmpl which is loaded by default */}}
{{- $valuesTemplate := $release | get "valuesTemplate" list -}}
{{- $release = set $release "valuesTemplate" (prepend $valuesTemplate "values.yaml.gotmpl") -}}

{{/* Append hooks */}}
{{- if hasKey $opts "hooks" -}}
  {{- $release = set $release "hooks" (concat $opts.hooks ($release | get "hooks" list)) -}}
{{- end -}}

{{- $release | toYaml -}}
