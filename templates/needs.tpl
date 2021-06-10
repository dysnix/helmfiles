{{/*
Example:

needs:
  - {{ tpl (readFile "../../templates/needs.tpl") (pick $release "kubeContext" "namespace" "name") . }}
*/}}

{{- list (. | get "kubeContext" "") .namespace .name | compact | join "/" -}}
