{{/* vim: set filetype=mustache: */}}
hooks:
{{- if .Values._set.postsync_crds }}
  - events: ["postsync"]
    command: "kubectl"
    args: ["--context", "{{`{{.Release.KubeContext}}`}}", "apply", "-f", "https://github.com/jetstack/cert-manager/releases/download/{{`{{.Release.Version}}`}}/cert-manager.crds.yaml"]

  ## Wait for cert-manager to process CRDs, so that webhooks are warmed up and helm can succeed.
  - events: ["postsync"]
    command: "sh"
    args: ["-c", "sleep 15"]
{{- else }}
  []
{{- end }}
