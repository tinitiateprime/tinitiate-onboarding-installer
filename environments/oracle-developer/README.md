# Oracle Developer appliance

This appliance provides Oracle Database Free, a browser-based VS Code workspace, and the Python `oracledb` driver. Host DBeaver can connect with the same settings.

```bash
docker compose -f environments/oracle-developer/compose.yaml up -d --build
```

Open code-server at <http://localhost:8080>. Connect to Oracle at `localhost:1521/FREEPDB1` with user `tinitiate` and the classroom password, unless overridden in `.env`.

The Oracle image requires substantially more memory and startup time than the basic workspace. Allow at least 4 GB of Docker memory.

