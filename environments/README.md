# Student environment catalog

Each directory contains an independent Docker Compose choice. Run commands from the repository root so Compose reads the root `.env` file and mounts the repository as the student's project folder.

| Environment guide | Workspace | Local emulator |
| --- | --- | --- |
| [AWS](aws/README.md) | AWS CLI v2 and boto3 | Floci AWS on port 4566 |
| [Azure](azure/README.md) | Azure CLI and Azure Python SDKs | Floci Azure on port 4577 |
| [GCP](gcp/README.md) | Google Cloud CLI and Google Cloud Python SDKs | Floci GCP on port 4588 |
| [Snowflake](snowflake/README.md) | Snowflake CLI, connector, and Snowpark | None |
| [Databricks](databricks/README.md) | Databricks CLI, SDK, SQL connector, and Delta Lake | None |

The three Floci environments also expose the Floci UI on port 4500. The workspace editor is on port 8080 by default. Override ports in the root `.env` file when required.

Start one choice:

```bash
docker compose -f environments/aws/compose.yaml up -d --build
```

Stop the same choice without deleting its saved configuration:

```bash
docker compose -f environments/aws/compose.yaml down
```

Replace `aws` with `azure`, `gcp`, `snowflake`, or `databricks`.

Do not put access tokens or passwords in a Compose file. Configure real Snowflake or Databricks credentials from the workspace terminal; their configuration directories are stored in environment-specific Docker volumes and ignored by Git.
