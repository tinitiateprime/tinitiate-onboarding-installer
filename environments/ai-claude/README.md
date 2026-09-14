# AI - Claude appliance

> **First time using Docker?** Complete Parts 2–6 of the illustrated [student guide](../../docs/STUDENT-GUIDE.md), then return here for Claude credentials.

This appliance provides the Anthropic SDK, CrewAI, LangGraph, PostgreSQL with pgvector, and a MinIO data lake. The local services work without a Claude API key.

## Start

Start Docker Desktop, open PowerShell or Terminal at the repository root, and run:

```bash
docker compose -f environments/ai-claude/compose.yaml up -d --build
```

Check readiness:

```bash
docker compose -f environments/ai-claude/compose.yaml ps
```

Open code-server at <http://localhost:8080> and MinIO at <http://localhost:9001>. Both use the classroom credentials documented in the [student guide](../../docs/STUDENT-GUIDE.md).

## Verify the local stack

In the code-server terminal, run:

```bash
python -c "import anthropic, crewai, langgraph, psycopg, minio; print('AI Claude appliance is ready')"
```

## Configure Claude access

Follow [Part 10 of the student guide](../../docs/STUDENT-GUIDE.md#configure-an-ai-provider-only-when-required), place the instructor-approved value in `ANTHROPIC_API_KEY` inside `.env`, and restart the appliance.

Confirm that the key is present without printing it:

```bash
python -c "import os; print('Claude API key loaded:', bool(os.getenv('ANTHROPIC_API_KEY')))"
```

## Stop and troubleshoot

```bash
docker compose -f environments/ai-claude/compose.yaml logs --tail 100
docker compose -f environments/ai-claude/compose.yaml down
```

Never put the API key in a Python file, notebook, screenshot, or Git commit.
