# AI - AWS appliance

> **First time using Docker?** Complete Parts 2–6 of the illustrated [student guide](../../docs/STUDENT-GUIDE.md), then return here for Bedrock credentials.

This appliance provides the AWS Bedrock SDK (`boto3`), CrewAI, LangGraph, PostgreSQL with pgvector, and a MinIO data lake. Local database and data-lake exercises work without an AWS account.

## Before starting

1. Start Docker Desktop and wait for its engine-running message.
2. Open PowerShell on Windows or Terminal on macOS.
3. Move to the repository root.
4. Do not add AWS credentials unless an instructor says a Bedrock exercise requires them.

## Start

Run this command from the repository root:

```bash
docker compose -f environments/ai-aws/compose.yaml up -d --build
```

The first build can take 10–30 minutes. Check readiness:

```bash
docker compose -f environments/ai-aws/compose.yaml ps
```

Open:

- Workspace: <http://localhost:8080>
- MinIO data lake: <http://localhost:9001>
- Workspace password: `Tinitiate!23456`
- MinIO user: `tinitiate`
- MinIO password: `Tinitiate!23456`

## Verify the local stack

In code-server, select **Terminal** > **New Terminal**, then run:

```bash
python -c "import boto3, crewai, langgraph, psycopg, minio; print('AI AWS appliance is ready')"
```

## Configure Bedrock access

Only do this with instructor-approved AWS credentials. Follow [Part 10 of the student guide](../../docs/STUDENT-GUIDE.md#configure-an-ai-provider-only-when-required) and complete `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, optional `AWS_SESSION_TOKEN`, and `AWS_DEFAULT_REGION` in `.env`. Restart the appliance afterward.

Confirm that Python can see credentials without printing their values:

```bash
python -c "import boto3; print('AWS credentials loaded:', boto3.Session().get_credentials() is not None)"
```

## Stop and troubleshoot

```bash
docker compose -f environments/ai-aws/compose.yaml logs --tail 100
docker compose -f environments/ai-aws/compose.yaml down
```

Do not use `down -v` unless you intend to erase the PostgreSQL, MinIO, editor, and AWS configuration volumes.
