# On-premises database installer

> **First time using Docker?** Complete Parts 2–5 of the illustrated [student guide](../../docs/STUDENT-GUIDE.md), then return here for DBeaver connection details.

Install and run your course databases locally using Docker Desktop on Windows or macOS. SQL Server, PostgreSQL, and MySQL start by default. Oracle and DynamoDB Local are optional. Use desktop DBeaver for SQL databases and a DynamoDB SDK or CLI for DynamoDB Local.

## What is included

| Database | Container image | Host | Default port | Default database/user |
| --- | --- | --- | ---: | --- |
| Microsoft SQL Server Developer | `mcr.microsoft.com/mssql/server:2022-latest` | `localhost` | 1433 | `master` / `sa` |
| PostgreSQL with pgvector | `pgvector/pgvector:pg16` | `localhost` | 5432 | `tinitiate` / `tinitiate` |
| MySQL LTS | `mysql:8.4` | `localhost` | 3306 | `tinitiate` / `tinitiate` |
| Oracle Database Free (optional) | `gvenzl/oracle-free:23-slim-faststart` | `localhost` | 1521 | Service `FREEPDB1` / `tinitiate` |
| DynamoDB Local (optional) | `amazon/dynamodb-local:latest` | `localhost` | 8500 | Local emulator; dummy AWS credentials |

An initialization script embedded in the Compose YAML enables the `vector` extension automatically the first time the PostgreSQL data volume is created.

## Why this is separate from basic Compose

The repository-root `compose.yaml` contains only the browser development workspace. This on-premises stack contains only database servers. Keeping them separate lets an instructor give students the database stack only, or run it alongside the basic workspace when both are required.

## Before starting

1. Install and start Docker Desktop.
2. Give Docker Desktop at least 6 GB of memory when running all three databases together. SQL Server is the largest service.
3. SQL Server requires an x86-64 Docker host; on Apple Silicon, start PostgreSQL and MySQL using the selected-database command below. Allow additional memory if you also start Oracle.

No `.env` file is required. The YAML includes the classroom password `Tinitiate!23456` for the SQL databases. Ports bind to `127.0.0.1` so the databases are accessible only from this computer. These credentials are intended only for local student machines and must never be used for production or internet-accessible databases.

Instructors can optionally override passwords, ports, database names, users, and timezone through a `.env` file. SQL Server password overrides must contain uppercase and lowercase letters, a number, and a symbol.

## Start

Run from the repository root:

```bash
docker compose -f environments/onprem-db/compose.yaml up -d
```

Check readiness:

```bash
docker compose -f environments/onprem-db/compose.yaml ps
```

All three services should eventually show `healthy`. SQL Server normally takes longer than PostgreSQL and MySQL.

## DBeaver connections

### SQL Server

- Driver: SQL Server
- Host: `localhost`
- Port: value of `MSSQL_PORT`, default `1433`
- Database: `master`
- User: `sa`
- Password: `Tinitiate!23456`, unless overridden by `MSSQL_SA_PASSWORD`
- If prompted for encryption settings in a local class environment, enable **Trust server certificate**.

### PostgreSQL

- Driver: PostgreSQL
- Host: `localhost`
- Port: value of `POSTGRES_PORT`, default `5432`
- Database: `POSTGRES_DB`, default `tinitiate`
- User: `POSTGRES_USER`, default `tinitiate`
- Password: `Tinitiate!23456`, unless overridden by `POSTGRES_PASSWORD`

Verify pgvector after connecting:

```sql
SELECT extname, extversion
FROM pg_extension
WHERE extname = 'vector';
```

### MySQL

- Driver: MySQL
- Host: `localhost`
- Port: value of `MYSQL_PORT`, default `3306`
- Database: `MYSQL_DATABASE`, default `tinitiate`
- User: `MYSQL_USER`, default `tinitiate`
- Password: `Tinitiate!23456`, unless overridden by `MYSQL_PASSWORD`

## Run only selected databases

Start one database:

```bash
docker compose -f environments/onprem-db/compose.yaml up -d postgres
```

Start two databases:

```bash
docker compose -f environments/onprem-db/compose.yaml up -d postgres mysql
```

Start Oracle only:

```bash
docker compose -f environments/onprem-db/compose.yaml up -d oracle
```

Start DynamoDB Local only (also runs its volume-permissions initialization):

```bash
docker compose -f environments/onprem-db/compose.yaml up -d dynamodb
```

Start all five databases:

```bash
docker compose -f environments/onprem-db/compose.yaml --profile oracle --profile dynamodb up -d
```

Valid database service names are `mssql`, `postgres`, `mysql`, `oracle`, and `dynamodb`. Selecting an optional service explicitly enables it for that command. DynamoDB shows `running`; its one-time `dynamodb-init` helper should exit with code 0. The SQL services should become `healthy`.

### Oracle connection

In DBeaver select **Oracle**, host `localhost`, port `1521`, connection type **Service name**, service `FREEPDB1`, user `tinitiate`, and password `Tinitiate!23456`. The `ORACLE_*` values in `.env` override these defaults. Do not run this Oracle service and the Oracle Developer course environment together on the same port.

### Verify DynamoDB Local

From the project folder, run this using the Python installed by the basic installer (on macOS, activate `~/.tinitiate/venv` first):

```bash
python -m pip install boto3
python -c "import boto3; db = boto3.client('dynamodb', endpoint_url='http://localhost:8500', region_name='us-east-1', aws_access_key_id='test', aws_secret_access_key='test'); print(db.list_tables()['TableNames'])"
```

An empty list `[]` is successful before creating tables. Change the endpoint port if you set `DYNAMODB_PORT`. DynamoDB Local is an AWS emulator running on your computer; it needs no AWS account and is not a production on-premises database server.

## Useful commands

```bash
docker compose -f environments/onprem-db/compose.yaml logs -f
docker compose -f environments/onprem-db/compose.yaml restart postgres
docker compose -f environments/onprem-db/compose.yaml stop
docker compose -f environments/onprem-db/compose.yaml --profile oracle --profile dynamodb down
```

`down` removes the containers and network but preserves database data in named volumes. Use `down -v` only when you intentionally want to permanently delete every database and backup volume in this stack.

## Troubleshooting

- Change `MSSQL_PORT`, `POSTGRES_PORT`, or `MYSQL_PORT` in `.env` if the host port is already occupied.
- View one service's logs, for example: `docker compose -f environments/onprem-db/compose.yaml logs mssql`.
- If SQL Server stops during startup, verify its password complexity and increase Docker Desktop memory.
- PostgreSQL initialization scripts run only on a new empty volume. To add pgvector to an existing database, execute `CREATE EXTENSION IF NOT EXISTS vector;` manually.
- SQL Server containers require an x86-64 compatible Docker environment. This can limit use on ARM-based computers.
