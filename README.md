# Dysnix Hemlfiles

The repository aims to provide Dysnix opinionated in-home applications operation knowledge in the form of Helmfiles.

Main pillars driving the philosophy of the project:
  * Baked ready-to-use helmfiles.
  * Provide common and **repeatable value-interface** from release to release.
  * Provide configuration presets (including presets for Cloud Providers).
  * Do not obscure the target helm release configuration possible with helmfile.

## Usage

Surely you should have a recent helmfile available, you can grab it from [the official github page](https://github.com/roboll/helmfile).

### Add the repository into your helmfiles git repostory

```bash
git submodule add https://github.com/dysnix/helmfiles.git
```

### Connect required release(s) from your helmfile.yaml

```yaml
helmfiles:
  - path: helmfiles/releases/ingress-nginx/helmfile.yaml
```

For clarification the tree of your helmfiles git repository:


```bash
├── helmfile.yaml   --> the root helmfile
└── helmfiles       --> dysnix/helmfiles submodule
    ├── LICENSE
```

## Configuration patterns

For operation we leverage on mechanism to pass values to a child helmfile as long as passing values via **environments**. Not to abuse possible user's environment values, we reserve a number of keys prefixed with `_`, such as `_preset`, `_default`, `_setup`.

### Dynamic environments

We do not force specific environment name, i.e. environment can be any way as might need for your project.

```yaml
environments:
  {{ .Environment.Name }}:

helmfiles:
  - path: helmfiles/releases/ingress-nginx/helmfile.yaml
```

Invocation example:
```bash
helmfile -e mysuperenv list
# or
helmfile list
```

### Presets

Helmfile releases might be coming with specific presets which represent some operational knowledge for an application. This can be limiting of cpu or memory by default, enabling autoscaling for you or even offering some cloud provider specific settings.

Use preset inclusion as in the bellow example:

```yaml
helmfiles:
  - path: helmfiles/releases/ingress-nginx/helmfile.yaml
    values:
      - helmfiles/releases/ingress-nginx/presets/aws.yaml
```

You can also override a preset value:

```yaml
helmfiles:
  - path: helmfiles/releases/ingress-nginx/helmfile.yaml
    values:
      - _preset:
          limit_cpu: 137m
```

You might have noticed that we didn't specify any preset in the example above, however we override the preset value for `limit_cpu`. Indeed this is totally valid due to the fact that **the default preset values are set automatically**.

### Customize a release

Here we will show how to pass the helmfile configuration allowing an end-user still to do a customization. In other words make the full control over the helmfile release(s).

```yaml
helmfiles:
  - path: helmfiles/releases/ingress-nginx/helmfile.yaml
    values:
      - _setup:
          release:
            name: my-ingress
            values:
              - foo: bar
            valuesTemplate:
              - relatve_values.yaml.gotmpl
```

Basically, the value map passed as `_setup.release` is the main release helmfile configuration, thus you are free to use any key which is valid for a helmfile release.

One tricky moment here is that we translate path for some stanzas such as `values`, `secrets` etc. For these path you have specify path to included files **relative from your parent helmfile**, not from the child (the release which we are including).

## Contribute

### Generate a helmfile release

Please generate a helmfile release:

```bash
make release NAME=my-new-release
```

and open a PR :+1:.
