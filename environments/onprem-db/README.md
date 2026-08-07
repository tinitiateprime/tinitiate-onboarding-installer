# On-premises database Docker environment

This Compose project starts the three databases used in the Tinitiate Windows database onboarding guides. It is a database-only stack: use the host-installed DBeaver application, the basic code-server workspace, or another database client to connect.

## What is included

| Database | Container image | Host | Default port | Default database/user |
| --- | --- | --- | ---: | --- |
| Microsoft SQL Server Developer | `mcr.microsoft.com/mssql/server:2022-latest` | `localhost` | 1433 | `master` / `sa` |
| PostgreSQL with pgvector | `pgvector/pgvector:pg16` | `localhost` | 5432 | `tinitiate` / `tinitiate` |
| MySQL LTS | `mysql:8.4` | `localhost` | 3306 | `tinitiate` / `tinitiate` |

The PostgreSQL initialization script enables the `vector` extension automatically the first time its data volume is created.

## Why this is separate from basic Compose

The repository-root `compose.yaml` contains only the browser development workspace. This on-premises stack contains only database servers. Keeping them separate lets an instructor give students the database stack only, or run it alongside the basic workspace when both are required.

## Before starting

1. Install and start Docker Desktop.
2. Copy `.env.example` to `.env` in the repository root.
3. Replace every database password beginning with `change-me`.
4. Give Docker Desktop at least 6 GB of memory when running all three databases together. SQL Server is the largest service.

SQL Server requires a strong `MSSQL_SA_PASSWORD` containing uppercase and lowercase letters, a number, and a symbol.

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
- Password: `MSSQL_SA_PASSWORD` from `.env`
- If prompted for encryption settings in a local class environment, enable **Trust server certificate**.

### PostgreSQL

- Driver: PostgreSQL
- Host: `localhost`
- Port: value of `POSTGRES_PORT`, default `5432`
- Database: `POSTGRES_DB`, default `tinitiate`
- User: `POSTGRES_USER`, default `tinitiate`
- Password: `POSTGRES_PASSWORD` from `.env`

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
- Password: `MYSQL_PASSWORD` from `.env`

## Run only selected databases

Start one database:

```bash
docker compose -f environments/onprem-db/compose.yaml up -d postgres
```

Start two databases:

```bash
docker compose -f environments/onprem-db/compose.yaml up -d postgres mysql
```

Valid service names are `mssql`, `postgres`, and `mysql`.

## Useful commands

```bash
docker compose -f environments/onprem-db/compose.yaml logs -f
docker compose -f environments/onprem-db/compose.yaml restart postgres
docker compose -f environments/onprem-db/compose.yaml stop
docker compose -f environments/onprem-db/compose.yaml down
```

`down` removes the containers and network but preserves database data in named volumes. Use `down -v` only when you intentionally want to permanently delete every database and backup volume in this stack.

## Troubleshooting

- Change `MSSQL_PORT`, `POSTGRES_PORT`, or `MYSQL_PORT` in `.env` if the host port is already occupied.
- View one service's logs, for example: `docker compose -f environments/onprem-db/compose.yaml logs mssql`.
- If SQL Server stops during startup, verify its password complexity and increase Docker Desktop memory.
- PostgreSQL initialization scripts run only on a new empty volume. To add pgvector to an existing database, execute `CREATE EXTENSION IF NOT EXISTS vector;` manually.
- SQL Server containers require an x86-64 compatible Docker environment. This can limit use on ARM-based computers.

## Related onboarding guides

- [Tinitiate SQL Server installer guide](https://github.com/tinitiateprime/tinitiate-onboarding/blob/main/software-installers/windows/database-installers/ms-sql-server/README.md)
- [Tinitiate PostgreSQL installer guide](https://github.com/tinitiateprime/tinitiate-onboarding/blob/main/software-installers/windows/database-installers/postgresql/README.md)
- [Tinitiate MySQL installer guide](https://github.com/tinitiateprime/tinitiate-onboarding/blob/main/software-installers/windows/database-installers/mysql/README.md)

