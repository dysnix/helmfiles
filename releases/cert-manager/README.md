# cert-manager helmfile

## Usage

We assume that:
  * [dysnix/helmfiles](https://github.com/dysnix/helmfiles) are added as a submodule into your project.
  * submodules are initialized and updated which means that dysnix helmfiles are available under the path `helmfiles/`.

Place the bellow snippet to include the this helmfile into your helmfile:

```yaml
helmfiles:
  - path: helmfiles/releases/cert-manager/helmfile.yaml
```

Run the helmfile (not that the release name might be different):

```bash
helmfile -l name=cert-manager list
```

**cert-manager** helmfile deploys a release bundle of multiple charts, to make sure that all the charts are process use `-l bundle=cert-manager` selector:

```bash
helmfile -l bundle=cert-manager list
```

### Let's Encrypt

Let's encrypt is enabled by default. The cluster issuers will be deployed by default unless you override or unset the `_set.default_issuer`. When installing the Let's Encrypt cluster-wide issuers you will be required to provide the email for notifications, see the code bellow:

```yaml
helmfiles:
  - path: helmfiles/releases/cert-manager/helmfile.yaml
    values:
      -
        _set:
          letsencrypt:
            acme_email: myuser@for-le-reports.com
```
