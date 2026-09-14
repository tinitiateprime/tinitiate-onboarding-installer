# Databricks student Docker environment

> **First time using Docker?** Complete Parts 2–6 of the illustrated [student guide](../../docs/STUDENT-GUIDE.md), then return here for Databricks configuration.

This environment provides Databricks command-line, Python, SQL, Spark, and Delta Lake tools. It does not run a Databricks control plane locally; workspace operations require access to a real Databricks workspace.

## What is included

- **code-server:** Visual Studio Code in the browser, available on port 8080.
- **Databricks CLI:** Manages workspace resources and authentication.
- **Databricks SDK for Python:** Automates Databricks APIs from Python.
- **Databricks SQL Connector:** Connects Python applications to SQL warehouses.
- **Delta Lake and PySpark:** Supports local Spark and Delta exercises.
- **AWS and Azure Floci:** Local database and data-lake service endpoints for integration exercises.
- **Shared student tools:** Python, Jupyter, Node.js, npm, Git, and the standard editor extensions.

## Important points

- A Databricks workspace supplied by the instructor or organization is required for remote workspace operations.
- No workspace URL or access token is built into the image.
- Databricks configuration is stored in a dedicated volume at `/home/coder/.databricks`.
- The project repository is mounted at `/home/coder/project`.
- Never commit access tokens or the Databricks configuration file to Git.
- Delta Lake can be used for some local Spark exercises without connecting to a remote workspace.
- Local AWS and Azure data are persisted in environment-specific Docker volumes.

## Start

Run from the repository root:

```bash
docker compose -f environments/databricks/compose.yaml up -d --build
```

Open <http://localhost:8080> and sign in with the classroom password `Tinitiate!23456`. An instructor can optionally override it with `CODE_SERVER_PASSWORD` in `.env`.

## Configure and verify

Open the workspace terminal:

```bash
databricks version
databricks auth login --host https://your-workspace-host
databricks auth profiles
databricks current-user me
```

Replace the example host with the workspace URL supplied by the instructor. The login command may open a browser-based authorization flow.

## Local Python verification

```bash
python -c "import databricks.sdk; import databricks.sql; import delta; print('Databricks libraries are ready')"
pyspark --version
```

## Useful commands

```bash
docker compose -f environments/databricks/compose.yaml ps
docker compose -f environments/databricks/compose.yaml logs -f dev
docker compose -f environments/databricks/compose.yaml restart
docker compose -f environments/databricks/compose.yaml down
```

Use `down -v` only when you intend to erase the saved editor and Databricks authentication configuration.

## Troubleshooting

- If port 8080 is busy, change `CODE_SERVER_PORT` in `.env`.
- Confirm the workspace host begins with `https://` and does not contain an extra path.
- Run `databricks auth profiles` to verify which profile is active.
- Corporate VPN, proxy, browser restrictions, or firewall settings may interrupt authentication.
