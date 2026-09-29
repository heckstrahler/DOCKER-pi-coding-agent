FROM node:current-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    python3 \
    python3-pip \
    curl \
    neovim \
    ripgrep \
    && rm -rf /var/lib/apt/lists/*

COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

ENV UV_COMPILE_BYTECODE=1 \
    UV_LINK_MODE=copy \
    PYTHONUNBUFFERED=1 \
    IS_DOCKER=true

RUN npm install -g npm@latest
RUN npm install -g --ignore-scripts @earendil-works/pi-coding-agent

RUN useradd -m -s /bin/bash piuser

USER piuser
RUN mkdir -p /home/piuser/workspace /home/piuser/.pi/agent

WORKDIR /home/piuser/.pi/agent
COPY --chown=piuser:piuser models.json .

WORKDIR /home/piuser
COPY --chown=piuser:piuser entrypoint.sh .
RUN chmod +x entrypoint.sh

WORKDIR /home/piuser/workspace
ENTRYPOINT ["/home/piuser/entrypoint.sh"]

CMD ["bash"]
