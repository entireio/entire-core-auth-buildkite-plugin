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

## CI

`.buildkite/pipeline.yml` self-tests the plugin: it applies the plugin at
the commit under test (`#${BUILDKITE_COMMIT}`) against a real deployment,
so every build exercises the OIDC mint, the token exchange, and the
pinned git-remote-entire download. One-time Buildkite setup:

* New pipeline on this GitHub repo, steps configuration just
  `buildkite-agent pipeline upload` (no plugin — checkout is plain
  GitHub).
* Pipeline-level env:
  * `ENTIRE_CORE_AUTH_URL` — a staging entire-core base URL
  * `ENTIRE_CORE_AUTH_ACCOUNT` — an approved service account ULID
  * `ENTIRE_SELF_TEST_REPO` (optional) — an `entire://` URL the SA can
    read; enables the `git ls-remote` round trip
* Core-side: a provider binding for (this Buildkite org/pipeline, that
  SA) whose attribute_filter admits **all branches**, or PR builds fail
  the exchange. See entiredb's buildkite-pipeline-enrollment runbook.
