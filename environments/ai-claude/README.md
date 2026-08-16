# AI - Claude appliance

Provides the Anthropic SDK, CrewAI, LangGraph, PostgreSQL with pgvector, and a MinIO data lake. Set `ANTHROPIC_API_KEY` in `.env` to call Claude.

```bash
docker compose -f environments/ai-claude/compose.yaml up -d --build
```

