# %%RELEASE_NAME%% helmfile

## Usage

We assume that:
  * [dysnix/helmfiles](https://github.com/dysnix/helmfiles) are added as a submodule into your project.
  * submodules are initialized and updated which means that dysnix helmfiles are available under the path `helmfiles/`.

Place the bellow snippet to include the this helmfile into your helmfile:

```yaml
helmfiles:
  - path: helmfiles/releases/%%RELEASE_NAME%%/helmfile.yaml
```

Run the helmfile (not that the release name might be different):

```bash
helmfile -l name=%%RELEASE_NAME list
```

**%%RELEASE_NAME** helmfile deploys a release bundle of multiple charts, to make sure that all the charts are process use `-l bundle=%%RELEASE_NAME` selector:

```bash
helmfile -l bundle=%%RELEASE_NAME list
```
