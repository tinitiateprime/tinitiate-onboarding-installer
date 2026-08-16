FROM codercom/code-server:latest

USER root

ARG AI_PROVIDER=custom

ENV DEBIAN_FRONTEND=noninteractive \
    VIRTUAL_ENV=/opt/venv \
    PATH=/opt/venv/bin:$PATH \
    PIP_DISABLE_PIP_VERSION_CHECK=1

RUN apt-get update \
    && apt-get install -y --no-install-recommends curl git nodejs npm python3 python3-pip python3-venv \
    && rm -rf /var/lib/apt/lists/* \
    && python3 -m venv "$VIRTUAL_ENV"

COPY config/requirements.txt /tmp/requirements.txt
RUN pip install --no-cache-dir --upgrade pip \
    && pip install --no-cache-dir -r /tmp/requirements.txt \
       crewai langgraph sqlalchemy "psycopg[binary]" minio \
    && case "$AI_PROVIDER" in \
         aws) pip install --no-cache-dir boto3 ;; \
         azure) pip install --no-cache-dir azure-ai-projects azure-identity ;; \
         claude) pip install --no-cache-dir anthropic ;; \
         custom) pip install --no-cache-dir openai ;; \
         *) echo "Unsupported AI_PROVIDER: $AI_PROVIDER" >&2; exit 1 ;; \
       esac \
    && ln -sf /opt/venv/bin/python /usr/local/bin/python \
    && ln -sf /opt/venv/bin/pip /usr/local/bin/pip

COPY config/code-server-extensions.txt /tmp/code-server-extensions.txt
RUN mkdir -p /home/coder/.local/share/code-server/extensions \
    && chown -R coder:coder /home/coder/.local

USER coder
RUN sed '/^[[:space:]]*\($\|#\)/d' /tmp/code-server-extensions.txt \
      | xargs -r -n 1 code-server --install-extension

WORKDIR /home/coder/project

