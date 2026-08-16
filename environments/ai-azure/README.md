# AI - Azure appliance

Provides the Azure AI Foundry SDK, Azure Identity, CrewAI, LangGraph, PostgreSQL with pgvector, and a MinIO data lake. Set `AZURE_AI_PROJECT_ENDPOINT` and authenticate to Azure when Foundry access is required.

```bash
docker compose -f environments/ai-azure/compose.yaml up -d --build
```

