# AI - Custom appliance

Provides an OpenAI-compatible Python SDK, CrewAI, LangGraph, PostgreSQL with pgvector, and a MinIO data lake. By default the SDK endpoint points to an OpenAI-compatible model server on host port 11434. Override `CUSTOM_AI_BASE_URL`, `CUSTOM_AI_API_KEY`, and `CUSTOM_AI_MODEL` in `.env` as needed.

```bash
docker compose -f environments/ai-custom/compose.yaml up -d --build
```

