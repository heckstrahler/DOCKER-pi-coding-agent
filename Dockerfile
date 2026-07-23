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

RUN printf '{\n\
  "providers": {\n\
    "llama-cpp": {\n\
      "baseUrl": "http://localhost:8080/v1",\n\
      "api": "openai-completions",\n\
      "apiKey": "not-needed",\n\
      "compat": {\n\
        "supportsDeveloperRole": false\n\
      },\n\
      "models": [\n\
        {\n\
          "id": "Qwen3.6-27B-UD-Q6_K_XL.gguf",\n\
          "contextWindow": 99000\n\
        }\n\
      ]\n\
    }\n\
  }\n\
}\n' > /home/piuser/.pi/agent/models.json


WORKDIR /home/piuser/workspace

ENTRYPOINT ["/home/piuser/entrypoint.sh"]

CMD ["bash"]
