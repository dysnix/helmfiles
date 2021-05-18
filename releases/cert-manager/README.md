# Hemlfiles

## Requirements

- [helm](https://helm.sh/docs/intro/install/) v3
- [helmfile](https://github.com/roboll/helmfile#installation)
* helm-diff (plugin)
  - `helm plugin install https://github.com/databus23/helm-diff`


### Usage

How to apply cert-manager helm chart via helmfiles.

```bash
helmfile --environment [aws,gcp,azure; default: default] --state-values-set issuer=[cf,clouddns,route53; default: cf] --file ./helmfile.yaml sync
helmfile --environment gcp --state-values-set issuer=cf --file ./helmfile.yaml build
```
