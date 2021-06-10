{{- if not (hasKey .Values._set.letsencrypt "acme_email") -}}
  {{- fail "\n\n==> You must specify _set.letsencrypt.acme_email value!" -}}
{{- end }}
- |
  ---
  apiVersion: cert-manager.io/v1
  kind: ClusterIssuer
  metadata:
    name: letsencrypt-http01-prod
    namespace: cert-manager
  spec:
    acme:
      server: https://acme-v02.api.letsencrypt.org/directory
      email: {{ .Values._set.letsencrypt.acme_email }}
      privateKeySecretRef:
        name: letsencrypt-http01-prod
      solvers:
        # An empty 'selector' means that this solver matches all domains
        - selector: {}
          http01:
            ingress:
              class: {{ .Values._set.letsencrypt.ingress_class }}
  ---
  apiVersion: cert-manager.io/v1
  kind: ClusterIssuer
  metadata:
    name: letsencrypt-http01-staging
    namespace: cert-manager
  spec:
    acme:
      server: https://acme-staging-v02.api.letsencrypt.org/directory
      email: {{ .Values._set.letsencrypt.acme_email }}
      privateKeySecretRef:
        name: letsencrypt-http01-staging
      solvers:
        # An empty 'selector' means that this solver matches all domains
        - selector: {}
          http01:
            ingress:
              class: {{ .Values._set.letsencrypt.ingress_class }}
