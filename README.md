# entire-core-auth-buildkite-plugin

* Installs the git-remote-entire helper
* Grabs an `ENTIRE_TOKEN` from auth server

To get a Buildkite pipeline bootstrapped, put this into the "YAML Pipeline" UI:

```yaml
steps:
  - label: ":notebook: pipeline upload"
    plugins:
      - entireio/entire-core-auth#v0.2.0:
          url: "https://us.auth.partial.to"
          resource: "automation:aut_01KSKXHVCRJ7H4PNNWXWKPX20P"
    command: buildkite-agent pipeline upload
```

`resource` is the principal the build acts as, sent to the token exchange
verbatim. Enrolling a repo through entire-core is what declares the
automation; its enroll response returns `automation_id` as a **bare**
`aut_<ulid>`, and this config wants the **prefixed** `automation:aut_<ulid>`.
The plugin prefixes nothing — a bare id here fails the exchange.

`resource` replaced `account` in v0.2.0 (and the pipeline-level env var
`ENTIRE_CORE_AUTH_ACCOUNT` became `ENTIRE_CORE_AUTH_RESOURCE`). There is no
compatibility shim: v0.1.x pipelines must be re-scaffolded, or edited by hand,
to move to v0.2.0. An operator-bound service account (`svc_<ulid>`) is still a
valid `resource` — the rename is about which principals the key can name, not
a removal of the service-account exchange.

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
  * `ENTIRE_CORE_AUTH_RESOURCE` — a `resource` the deployment will issue a
    token for: `svc_<ulid>` for an approved service account, or
    `automation:aut_<ulid>` for an automation
  * `ENTIRE_SELF_TEST_REPO` (optional) — an `entire://` URL that principal
    can read; enables the `git ls-remote` round trip
* Core-side: a provider binding for (this Buildkite org/pipeline, that
  principal) whose attribute_filter admits **all branches**, or PR builds
  fail the exchange. See the buildkite-ci-setup runbook in
  entirehq/entire-ci-webhooks.
