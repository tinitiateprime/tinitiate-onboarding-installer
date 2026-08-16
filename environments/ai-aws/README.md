# AI - AWS appliance

Provides the AWS Bedrock SDK (`boto3`), CrewAI, LangGraph, PostgreSQL with pgvector, and a MinIO data lake. Add AWS credentials to `.env` only when Bedrock access is required.

```bash
docker compose -f environments/ai-aws/compose.yaml up -d --build
```

