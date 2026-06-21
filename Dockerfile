# syntax=docker/dockerfile:1
#
# Agentic Redteam(TM) — AI-augmented penetration testing
# Built on Kali Linux, driven by Claude Code.
# Copyright (c) 2026 Shad Nygren / Virtual Hipster Corporation · Apache-2.0 License
#
# Base-image choice (decided): kali-last-release by default — quarterly point
# releases => reproducible CI builds + a stable, predictable distributed image.
# Override to the weekly bleeding-edge with:  --build-arg KALI_TAG=kali-rolling
ARG KALI_TAG=kali-last-release
FROM kalilinux/${KALI_TAG}

# Which Kali metapackage to install. The base image is bare-bones (no tools).
#   kali-linux-headless  -> the standard CLI toolset, no desktop (default; Claude drives via CLI)
#   kali-tools-top10     -> just the 10 most popular tools (lean image, faster CI)
#   kali-linux-large     -> the full desktop-ISO suite
ARG TOOLSET=kali-linux-headless

LABEL org.opencontainers.image.title="Agentic Redteam" \
      org.opencontainers.image.description="AI-augmented penetration testing — built on Kali Linux, driven by Claude Code" \
      org.opencontainers.image.source="https://github.com/ShadNygren/agentic-redteam" \
      org.opencontainers.image.licenses="Apache-2.0" \
      org.opencontainers.image.authors="Shad Nygren / Virtual Hipster Corporation"

ENV DEBIAN_FRONTEND=noninteractive \
    AGENTIC_REDTEAM_HOME=/opt/agentic-redteam

# 1) Kali toolset + base utilities
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
      ${TOOLSET} \
      ca-certificates curl git jq ripgrep \
      python3 python3-pip pipx \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# 2) Node.js 20 LTS (required by Claude Code) via NodeSource
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
 && apt-get install -y --no-install-recommends nodejs \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# 3) Claude Code CLI (the orchestration layer). Provide ANTHROPIC_API_KEY at run time.
RUN npm install -g @anthropic-ai/claude-code \
 && npm cache clean --force

# 4) The value-add: the Claude Code skills (pentest + redteam), the methodology docs, and tests.
#    Skills are placed where Claude Code auto-discovers them (~/.claude/skills/).
COPY skills/ /root/.claude/skills/
RUN mkdir -p ${AGENTIC_REDTEAM_HOME}
COPY docs/   ${AGENTIC_REDTEAM_HOME}/docs/
COPY tools/  ${AGENTIC_REDTEAM_HOME}/tools/
COPY tests/  ${AGENTIC_REDTEAM_HOME}/tests/
COPY README.md SECURITY.md NOTICE LICENSE ${AGENTIC_REDTEAM_HOME}/
RUN chmod +x ${AGENTIC_REDTEAM_HOME}/tests/*.sh /root/.claude/skills/*/scripts/*.sh \
      ${AGENTIC_REDTEAM_HOME}/tools/bayesian/*.py 2>/dev/null || true

# 5) Engagement workspace — mount a volume here: authorization/scope files IN, report OUT.
WORKDIR /work
VOLUME ["/work"]

# Drop into a shell; `claude` is on PATH and the `pentest` skill is preloaded.
# AUTHORIZED TESTING ONLY — see SECURITY.md.
CMD ["/bin/bash"]
