# dbt appliance

> **First time using Docker?** Complete Parts 2–6 of the illustrated [student guide](../../docs/STUDENT-GUIDE.md), then return here for dbt profiles and targets.

This appliance includes dbt Core with PostgreSQL, Snowflake, and Databricks adapters; a local PostgreSQL analytics target; and local AWS and Azure Floci data-lake endpoints.

## Before starting

1. Start Docker Desktop.
2. Open PowerShell or Terminal.
3. Move to the repository root.

## Start

```bash
docker compose -f environments/dbt/compose.yaml up -d --build
```

Check readiness:

```bash
docker compose -f environments/dbt/compose.yaml ps
```

Open code-server at <http://localhost:8080>, sign in with `Tinitiate!23456`, and open **Terminal** > **New Terminal**.

Verify dbt:

```bash
dbt --version
```

## Create a first local PostgreSQL project

Run this in the code-server terminal:

```bash
cd /home/coder/project
dbt init student_analytics
```

When dbt asks questions, choose the PostgreSQL adapter and enter:

| Prompt | Value |
| --- | --- |
| Host | `postgres` |
| Port | `5432` |
| User | `tinitiate` |
| Password | `Tinitiate!23456` |
| Database | `analytics` |
| Schema | `public` |
| Threads | `4` |

dbt saves the connection profile in `/home/coder/.dbt/profiles.yml`. That directory persists in a Docker volume.

Test the project:

```bash
cd /home/coder/project/student_analytics
dbt debug
dbt run
dbt test
```

`All checks passed` from `dbt debug` indicates that the profile can reach PostgreSQL.

## Cloud targets

The Snowflake adapter is installed for Snowflake projects, but Snowflake does not provide a supported local database server. Configure a Snowflake cloud account in the dbt profile when that target is required.

The Databricks adapter is also installed. AWS and Azure Floci provide local data-lake endpoints, but they do not replace a Snowflake or Databricks SQL warehouse. Use only cloud account details supplied by the instructor.

## Stop and troubleshoot

```bash
docker compose -f environments/dbt/compose.yaml logs --tail 100
docker compose -f environments/dbt/compose.yaml down
```

- Use host `postgres`, not `localhost`, inside the dbt profile.
- If `dbt debug` reports authentication failure, recheck the user, password, and database.
- Do not use `down -v` unless you intend to erase PostgreSQL data and saved dbt profiles.
