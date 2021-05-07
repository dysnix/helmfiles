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
