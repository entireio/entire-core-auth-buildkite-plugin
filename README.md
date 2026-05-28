# entire-core-auth-buildkite-plugin

* Installs the git-remote-entire helper
* Grabs an `ENTIRE_TOKEN` from auth server

To get a Buildkite pipeline bootstrapped, put this into the "YAML Pipeline" UI:

```yaml
steps:
  - label: ":notebook: pipeline upload"
    plugins:
      - entireio/entire-core-auth#v0.1.1:
          url: "https://us.auth.partial.to"
          account: "svc_01KSKXHVCRJ7H4PNNWXWKPX20P"
    command: buildkite-agent pipeline upload
```
