# Student environment catalog

**Step 1:** [Install the base software](../README.md#step-1-install-the-base-software) on your computer. **Step 2:** start only the course environment assigned by your instructor. Docker Desktop runs the tools and databases for that course and sets up the included software automatically. If no course environment has been assigned yet, stop after Step 1. New students can follow the [illustrated setup guide](../docs/STUDENT-GUIDE.md).

Each directory contains an independent Docker Compose choice. Run commands from the repository root so Compose reads the root `.env` file and mounts the repository as the student's project folder.

| Environment guide | Workspace | Local emulator |
| --- | --- | --- |
| [AWS](aws/README.md) | AWS CLI v2 and boto3 | Floci AWS on port 4566 |
| [Azure](azure/README.md) | Azure CLI and Azure Python SDKs | Floci Azure on port 4577 |
| [GCP](gcp/README.md) | Google Cloud CLI and Google Cloud Python SDKs | Floci GCP on port 4588 |
| [Snowflake](snowflake/README.md) | Snowflake CLI, connector, and Snowpark | None |
| [Oracle Developer](oracle-developer/README.md) | Oracle Python development workspace | Oracle Database Free |
| [AI - AWS](ai-aws/README.md) | Bedrock SDK, CrewAI, and LangGraph | PostgreSQL/pgvector and MinIO |
| [AI - Azure](ai-azure/README.md) | Foundry SDK, CrewAI, and LangGraph | PostgreSQL/pgvector and MinIO |
| [AI - Claude](ai-claude/README.md) | Anthropic SDK, CrewAI, and LangGraph | PostgreSQL/pgvector and MinIO |
| [AI - Custom](ai-custom/README.md) | OpenAI-compatible SDK, CrewAI, and LangGraph | PostgreSQL/pgvector and MinIO |
| [Databricks](databricks/README.md) | Databricks CLI, SDK, SQL connector, and Delta Lake | AWS and Azure Floci |
| [dbt](dbt/README.md) | dbt PostgreSQL, Snowflake, and Databricks adapters | PostgreSQL plus AWS and Azure Floci |
| [On-premises databases](onprem-db/README.md) | SQL Server, PostgreSQL with pgvector, MySQL; optional Oracle and DynamoDB Local | Local database servers |

The standalone AWS, Azure, and GCP appliances expose the Floci UI on port 4500. Databricks and dbt use Floci as internal data-lake services without starting the UI. All choices except On-premises databases include a workspace editor on port 8080 with the classroom password `Tinitiate!23456` by default. For On-premises databases, open the desktop DBeaver application instead. No `.env` file is required for local classroom defaults; instructors can use one for optional overrides and cloud credentials.

Start one choice:

```bash
docker compose -f environments/aws/compose.yaml up -d --build
```

Stop the same choice without deleting its saved configuration:

```bash
docker compose -f environments/aws/compose.yaml down
```

Replace `aws` with any directory listed in the catalog above.

Do not put access tokens or passwords in a Compose file. Configure real Snowflake or Databricks credentials from the workspace terminal; their configuration directories are stored in environment-specific Docker volumes and ignored by Git.
