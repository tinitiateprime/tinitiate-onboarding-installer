FROM codercom/code-server:latest

USER root

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
    && ln -sf /opt/venv/bin/python /usr/local/bin/python \
    && ln -sf /opt/venv/bin/pip /usr/local/bin/pip

USER root

RUN pip install --no-cache-dir \
      snowflake-cli \
      snowflake-connector-python[pandas] \
      snowflake-snowpark-python

COPY config/code-server-extensions.txt /tmp/code-server-extensions.txt
RUN mkdir -p /home/coder/.local/share/code-server/extensions \
    && chown -R coder:coder /home/coder/.local

USER coder
RUN sed '/^[[:space:]]*\($\|#\)/d' /tmp/code-server-extensions.txt \
      | xargs -r -n 1 code-server --install-extension

WORKDIR /home/coder/project
