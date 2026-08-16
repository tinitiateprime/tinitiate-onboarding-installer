# dbt appliance

This appliance includes dbt Core with PostgreSQL, Snowflake, and Databricks adapters; a local PostgreSQL analytics target; and local AWS and Azure Floci data-lake endpoints.

```bash
docker compose -f environments/dbt/compose.yaml up -d --build
```

Run `dbt --version` in code-server at <http://localhost:8080>. The local PostgreSQL target is immediately available. Create profiles in `/home/coder/.dbt/profiles.yml`; that directory persists in a Docker volume.

The Snowflake adapter is installed for Snowflake projects, but Snowflake does not provide a supported local database server. Configure a Snowflake cloud account in the dbt profile when that target is required.

