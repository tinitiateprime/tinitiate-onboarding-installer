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

RUN apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates gnupg \
    && curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg \
       | gpg --dearmor -o /usr/share/keyrings/cloud.google.gpg \
    && echo 'deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main' \
       > /etc/apt/sources.list.d/google-cloud-sdk.list \
    && apt-get update \
    && apt-get install -y --no-install-recommends google-cloud-cli \
    && rm -rf /var/lib/apt/lists/* \
    && pip install --no-cache-dir google-cloud-storage google-cloud-pubsub google-cloud-firestore

COPY config/code-server-extensions.txt /tmp/code-server-extensions.txt
RUN mkdir -p /home/coder/.local/share/code-server/extensions \
    && chown -R coder:coder /home/coder/.local

USER coder
RUN sed '/^[[:space:]]*\($\|#\)/d' /tmp/code-server-extensions.txt \
      | xargs -r -n 1 code-server --install-extension

WORKDIR /home/coder/project
