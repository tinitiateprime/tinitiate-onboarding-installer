# AI - Azure appliance

> **First time using Docker?** Complete Parts 2–6 of the illustrated [student guide](../../docs/STUDENT-GUIDE.md), then return here for Foundry credentials.

This appliance provides the Azure AI Foundry SDK, Azure Identity, CrewAI, LangGraph, PostgreSQL with pgvector, and a MinIO data lake. Local database and data-lake exercises work without an Azure account.

## Before starting

1. Start Docker Desktop and wait for its engine-running message.
2. Open PowerShell on Windows or Terminal on macOS.
3. Move to the repository root.
4. Do not add Azure credentials unless an instructor says a Foundry exercise requires them.

## Start

Run this command from the repository root:

```bash
docker compose -f environments/ai-azure/compose.yaml up -d --build
```

Check readiness:

```bash
docker compose -f environments/ai-azure/compose.yaml ps
```

Open:

- Workspace: <http://localhost:8080>
- MinIO data lake: <http://localhost:9001>
- Workspace password: `Tinitiate!23456`
- MinIO user: `tinitiate`
- MinIO password: `Tinitiate!23456`

## Verify the local stack

Open **Terminal** > **New Terminal** in code-server and run:

```bash
python -c "import azure.ai.projects, crewai, langgraph, psycopg, minio; print('AI Azure appliance is ready')"
```

## Configure Foundry access

Only use an instructor-approved service principal. Follow [Part 10 of the student guide](../../docs/STUDENT-GUIDE.md#configure-an-ai-provider-only-when-required) and complete `AZURE_AI_PROJECT_ENDPOINT`, `AZURE_AI_MODEL_DEPLOYMENT_NAME`, `AZURE_CLIENT_ID`, `AZURE_TENANT_ID`, and `AZURE_CLIENT_SECRET` in `.env`. Restart the appliance afterward.

Confirm that the variables are present without displaying their values:

```bash
python -c "import os; names=['AZURE_AI_PROJECT_ENDPOINT','AZURE_CLIENT_ID','AZURE_TENANT_ID','AZURE_CLIENT_SECRET']; print({n: bool(os.getenv(n)) for n in names})"
```

## Stop and troubleshoot

```bash
docker compose -f environments/ai-azure/compose.yaml logs --tail 100
docker compose -f environments/ai-azure/compose.yaml down
```

Do not use `down -v` unless you intend to erase the PostgreSQL, MinIO, editor, and Azure configuration volumes.
