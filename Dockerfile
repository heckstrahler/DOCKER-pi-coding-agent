FROM node:current-slim

RUN apt-get update && apt-get install -y \
    git \
    python3 \
    python3-pip \
    curl \
    neovim \
    ripgrep \
    curl \
    && rm -rf /var/lib/apt/lists/*

COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

ENV UV_COMPILE_BYTECODE=1 \
    UV_LINK_MODE=copy \
    PYTHONUNBUFFERED=1

RUN npm install -g npm@latest
RUN npm install -g --ignore-scripts @earendil-works/pi-coding-agent



RUN useradd -m -s /bin/bash piuser
WORKDIR /home/piuser
COPY ./entrypoint.sh .
RUN chmod 755 entrypoint.sh
USER piuser


RUN mkdir -p /home/piuser/workspace /home/piuser/.pi

ENV IS_DOCKER=true

RUN mkdir -p ~/.pi/agent/

WORKDIR /home/piuser/.pi/agent
COPY models.json .

WORKDIR /home/piuser/workspace

ENTRYPOINT ["/home/piuser/entrypoint.sh"]

CMD ["bash"]
