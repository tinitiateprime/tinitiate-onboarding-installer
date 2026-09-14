# Oracle Developer appliance

> **First time using Docker?** Complete Parts 2–6 of the illustrated [student guide](../../docs/STUDENT-GUIDE.md), then return here for Oracle connection details.

This appliance provides Oracle Database Free, a browser-based VS Code workspace, and the Python `oracledb` driver. Host DBeaver can connect with the same settings.

## Before starting

1. Start Docker Desktop.
2. In Docker Desktop settings, allow at least 4 GB of memory.
3. Open PowerShell or Terminal and move to the repository root.

## Start

```bash
docker compose -f environments/oracle-developer/compose.yaml up -d --build
```

Oracle can take several minutes to start. Check until both services are running and Oracle is healthy:

```bash
docker compose -f environments/oracle-developer/compose.yaml ps
```

Open code-server at <http://localhost:8080> and sign in with `Tinitiate!23456`.

## Verify from code-server

Select **Terminal** > **New Terminal**, then run:

```bash
python -c "import oracledb; connection=oracledb.connect(user='tinitiate', password='Tinitiate!23456', dsn='oracle:1521/FREEPDB1'); print('Oracle version:', connection.version); connection.close()"
```

## Connect with DBeaver

Follow the illustrated [DBeaver steps](../../docs/STUDENT-GUIDE.md#connect-with-dbeaver) using:

- Database type: Oracle
- Host: `localhost`
- Port: `1521`
- Service name: `FREEPDB1`
- User: `tinitiate`
- Password: `Tinitiate!23456`

Use **Service name**, not SID, if DBeaver offers both choices.

## Stop and troubleshoot

```bash
docker compose -f environments/oracle-developer/compose.yaml logs --tail 100
docker compose -f environments/oracle-developer/compose.yaml down
```

The Oracle image requires substantially more memory and startup time than the basic workspace. Allow at least 4 GB of Docker memory.

Do not use `down -v` unless you intentionally want to erase the Oracle database and editor data.
