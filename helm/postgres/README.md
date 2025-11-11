# Postgres Helm Chart

This chart provisions a single-node PostgreSQL instance backed by a persistent volume claim.

## Installation

```bash
helm upgrade --install postgres ./helm/postgres \
  --namespace database \
  --create-namespace
```

Override the defaults via `--set key=value` or `-f custom-values.yaml`.

### Useful Parameters

| Key | Description | Default |
| --- | --- | --- |
| `postgresql.username` | Database superuser | `app_user` |
| `postgresql.password` | Password used when `existingSecret` is empty | `changeme` |
| `postgresql.database` | Database created on bootstrap | `app_db` |
| `postgresql.existingSecret` | Provide an existing secret name that stores the password | `""` |
| `persistence.size` | Requested PVC size | `1Gi` |
| `persistence.storageClass` | StorageClass for PV (keeps cluster default when empty) | `""` |

Set `postgresql.existingSecret` when you already manage the password and leave `postgresql.password` unused.

## GitHub Actions Deployment

The workflow in `.github/workflows/deploy-postgres.yaml` deploys this chart to OpenShift (OCP) every time changes land on `main` or when manually triggered. Configure these repository secrets:

- `OPENSHIFT_SERVER`: API endpoint of your OpenShift cluster.
- `OPENSHIFT_TOKEN`: Service account/token with rights to install into the target namespace.
- `OPENSHIFT_NAMESPACE`: Default namespace the workflow will use unless overridden via manual inputs.
- `POSTGRES_PASSWORD`: (optional) overrides `postgresql.password` during deploys.
- `HELM_EXTRA_ARGS`: (optional) any extra flags like `--set persistence.size=5Gi`.

The workflow logs in using `redhat-actions/oc-login`, then performs `helm upgrade --install`. Manual dispatch events let you override the release or namespace when needed.
