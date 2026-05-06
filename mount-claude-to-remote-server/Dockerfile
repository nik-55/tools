FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

# SSH client for remote shell; sshfs + fuse3 for full-access filesystem mount; Node.js for Claude Code
RUN apt-get update && apt-get install -y \
    openssh-client \
    sshfs \
    fuse3 \
    nodejs \
    npm \
    && rm -rf /var/lib/apt/lists/*

# Install Claude Code CLI
RUN npm install -g @anthropic-ai/claude-code

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
