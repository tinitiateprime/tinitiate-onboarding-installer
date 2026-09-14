# Azure student Docker environment

> **First time using Docker?** Complete Parts 2–6 of the illustrated [student guide](../../docs/STUDENT-GUIDE.md), then return here for Azure-specific exercises.

This environment provides Azure development tools together with a local Azure-compatible emulator. Students can practice supported Storage and Functions workflows without connecting to a paid Azure subscription.

## What is included

- **code-server:** Visual Studio Code in the browser, available on port 8080.
- **Azure CLI:** Runs `az` commands from the workspace terminal.
- **Azure Python SDKs:** Includes identity, Blob Storage, and Queue Storage packages.
- **Floci Azure:** Locally emulates Azure services on port 4577.
- **Floci UI:** Provides a browser dashboard on port 4500.
- **Shared student tools:** Python, PySpark, Jupyter, Node.js, npm, Git, and the standard editor extensions.

## Important points

- `AZURE_STORAGE_CONNECTION_STRING` is preconfigured for the `floci-azure` container.
- `FLOCI_AZURE_ACCOUNT_KEY` defaults to a harmless Base64-encoded local signing value. It is test data, not an Azure-issued key.
- Supported local operations include Blob, Queue, and Table Storage; Floci can also execute Azure Functions through Docker.
- General Azure management commands may still require a real subscription and `az login`.
- Azure CLI configuration, editor settings, and emulator data use separate named volumes.
- The Docker socket is mounted into Floci for local Functions execution. Only use trusted course code and images.

## Start

Run from the repository root:

```bash
docker compose -f environments/azure/compose.yaml up -d --build
```

Open:

- Workspace: <http://localhost:8080>
- Floci UI: <http://localhost:4500>
- Floci Azure API: <http://localhost:4577>

## Verify and try Blob Storage

Open the workspace terminal and run:

```bash
az version
az storage container create \
  --name student-demo \
  --connection-string "$AZURE_STORAGE_CONNECTION_STRING"
az storage container list \
  --connection-string "$AZURE_STORAGE_CONNECTION_STRING" \
  --output table
```

Always supply the local connection string for Floci storage exercises. Use `az login` only when an instructor explicitly requires a real Azure subscription.

## Useful commands

```bash
docker compose -f environments/azure/compose.yaml ps
docker compose -f environments/azure/compose.yaml logs -f floci-azure
docker compose -f environments/azure/compose.yaml restart
docker compose -f environments/azure/compose.yaml down
```

Use `down -v` only when you intend to erase the saved Azure configuration, editor data, and locally emulated resources.

## Troubleshooting

- If port 4577, 4500, or 8080 is busy, change the corresponding value in `.env`.
- If a storage command tries to reach Azure, confirm that `--connection-string "$AZURE_STORAGE_CONNECTION_STRING"` was included.
- Check `docker compose -f environments/azure/compose.yaml logs floci-azure` when the emulator is unavailable.
