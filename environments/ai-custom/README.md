# AI - Custom appliance

> **First time using Docker?** Complete Parts 2–6 of the illustrated [student guide](../../docs/STUDENT-GUIDE.md), then return here for model-server configuration.

This appliance provides an OpenAI-compatible Python SDK, CrewAI, LangGraph, PostgreSQL with pgvector, and a MinIO data lake. By default, the SDK endpoint points to an OpenAI-compatible model server running on the host at port 11434.

## Before starting

Ask the instructor which model server to use. The model server is separate from this appliance and must already be running when the course calls it.

## Start

Start Docker Desktop, open PowerShell or Terminal at the repository root, and run:

```bash
docker compose -f environments/ai-custom/compose.yaml up -d --build
```

Check readiness:

```bash
docker compose -f environments/ai-custom/compose.yaml ps
```

Open code-server at <http://localhost:8080> and MinIO at <http://localhost:9001>.

## Verify the local stack

In the code-server terminal, run:

```bash
python -c "import openai, crewai, langgraph, psycopg, minio; print('AI custom appliance is ready')"
```

## Configure the model server

Follow [Part 10 of the student guide](../../docs/STUDENT-GUIDE.md#configure-an-ai-provider-only-when-required). In `.env`, set `CUSTOM_AI_BASE_URL`, `CUSTOM_AI_API_KEY`, and `CUSTOM_AI_MODEL` to values supplied by the instructor. Restart the appliance afterward.

The default base URL is:

```text
http://host.docker.internal:11434/v1
```

Confirm the settings are present without printing the API key:

```bash
python -c "import os; print('URL:', os.getenv('OPENAI_BASE_URL')); print('Model set:', bool(os.getenv('CUSTOM_AI_MODEL'))); print('Key set:', bool(os.getenv('OPENAI_API_KEY')))"
```

## Stop and troubleshoot

```bash
docker compose -f environments/ai-custom/compose.yaml logs --tail 100
docker compose -f environments/ai-custom/compose.yaml down
```

If local model calls fail, confirm the model server is running on the host, uses an OpenAI-compatible API, and allows connections from Docker Desktop.
