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

For operation we leverage on mechanism to pass values to a child helmfile as long as passing values via **environments** is possible. Not to abuse possible user's environment values, we reserve a number of keys prefixed with `_`, such as `_set`, `_use` and `_default`.

### Dynamic environments

We do not force specific environment name, i.e. environment name can be any as you choose for your project.

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
      - _set:
          resources:
            limits:
              cpu: 137m
```

You might have noticed that we didn't specify any preset in the example above, however we override the preset value for `_set.resources.limit.cpu`. Indeed this is totally valid due to the fact that **the default preset values are set automatically** (well depends might depend on a release, ingress-nginx does have the default resources).

### Customize a release

Here we will show how to pass the helmfile configuration allowing an end-user still to do a customization. In other words make the full control over the helmfile release(s).

```yaml
helmfiles:
  - path: helmfiles/releases/ingress-nginx/helmfile.yaml
    values:
      - _use:
          release:
            name: my-ingress
            values:
              - foo: bar
            valuesTemplate:
              - relatve_values.yaml.gotmpl
```

Basically, the value map passed as `_use.release` is the main release helmfile configuration, thus you are free to use any key which is valid for a helmfile release.

One tricky moment here is that we translate paths in some stanzas such as `values`, `secrets` etc. For these paths you have to specify a path **relative from your parent helmfile**, but not from the child (i.e the release which we are including).

## Interacting with _use and _set

As you might noticed we use both keys `_use` and `_set`. The former is used for the helmfile specific settings such as `release.values`, `release.valuesTemplate` etc, basically `_use` contents is passed almost as-is to the inner helmfile release(s). While the later (`_set`) is related to the release specific customizations and is intended to specify the configuration interface for resources, autoscaling, affinity and *for everything else what the specific helmfile aims to provide to an end-user*.

Note: that the `_set` interface *does not aim to line-up* with the underlying chart values interface, but rather tries to provide a common from helmfile to helmfile values interface. Again the idea is to provide a common way **to manage chart with different configuration values with the same preset values** where possible. 

For more details on each helmfile release refer to `releases/RELEASE_NAME/default.yaml` and `releases/RELEASE_NAME/preset/*.yaml` files.

## Contribute

### Generate a helmfile release

Please generate a helmfile release:

```bash
make release NAME=my-new-release
```

and open a PR :+1:.
