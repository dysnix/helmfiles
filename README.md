# Hemlfiles

## Requirements

- [helm](https://helm.sh/docs/intro/install/) v3
- [helmfile](https://github.com/roboll/helmfile#installation)
* helm-diff (plugin)
  - `helm plugin install https://github.com/databus23/helm-diff`


### Usage

How to apply nginx-ingress helm chart via helmfiles.

```bash
helmfile --environment [aws,gcp,azure; default: default] helmfile.yaml
```

### Refactored Usage
We have
```bash
├── helmfile.yaml   --> example is described
└── helmfiles
    ├── LICENSE
    ├── Makefile
    ├── NOTICE
    ├── README.md
    └── releases
        ├── env.yaml.gotmpl
        └── ingress-nginx
            ├── defaults.yaml
            ├── helmfile.yaml
            ├── presets
            │   ├── aws.yaml
            │   ├── azure.yaml
            │   └── gcp.yaml
            └── values.yaml.gotmpl
```

helmfile.yaml
```yaml
environments:
  {{ .Environment.Name }}:

helmfiles:
- path: helmfiles/releases/ingress-nginx/helmfile.yaml
  values:
    # 1. Release Values
    - version: 3.30.0
    - name: my-super-ingress
    # 2. Preset usage
    - helmfiles/releases/ingress-nginx/presets/aws.yaml
    # 3. Preset overrides
    - preset:
        limit_cpu: 500m
    # 4. Pass releases.* parameters to helmfile (ingress-nginx)
    - secrets:
      - path/to/vault_secret.yaml
```
