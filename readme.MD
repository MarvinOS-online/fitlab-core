MarvinOS Local AI Stack

A fully self-hosted, GPU-accelerated AI stack designed for local experimentation, secure internal use, offline environments, and MarvinOS development.

This stack is Docker-based, reproducible, and designed to survive rebuilds without data loss.

✨ Features

Fully local LLM inference (no cloud dependency)

GPU-accelerated (NVIDIA)

HTTPS ingress with Nginx

Web-based chat UI (Open WebUI)

Private web search grounding (SearXNG)

Local OpenAI-compatible TTS

Stable Diffusion-based image creation (local GPU inference)

One-shot configuration + model preload jobs

Persistent data stored outside the repo

🧠 Stack Components

Ollama — Local LLM runtime (GPU accelerated)

Open WebUI — Chat interface

Nginx — TLS ingress + reverse proxy

SearXNG — Private meta-search engine

openai-edge-tts — Local OpenAI-compatible TTS

Stable Diffusion (automatic1111) — Local image generation API

One-shot config & model pull containers

🏗 Architecture Overview

User
 └─ HTTPS (Nginx Ingress)
     └─ Open WebUI
         ├─ Ollama (LLMs, GPU)
         ├─ Stable Diffusion API (Image Generation)
         ├─ SearXNG (Web Search)
         └─ openai-edge-tts (Speech)


Persistent data is stored outside the repository under:
../MarvinOS_Data

📦 Services

configure_ingress

One-shot container

Copies curated Nginx configs and HTML assets

Generates or installs SSL certificates

Writes everything into persistent volumes under MarvinOS_Data

Runs once and exits

configure_searxng

One-shot container

Copies curated SearXNG configuration into persistent storage

Runs once and exits

ingress (Nginx)

Public entry point, listens on 80 / 443

Terminates TLS (self-signed by default)

Proxies traffic to Open WebUI

Healthcheck via nginx -t

ollama

Local GPU-accelerated LLM runtime, port 11434

Supports NVIDIA GPUs

Tuned via environment variables (Flash Attention, KV cache, GPU layers)

Persistent storage: ../MarvinOS_Data/ollama

pull-llm- (Model Jobs)*

One-shot model download containers

Preload models into persistent storage

Safe to re-run or remove

open-webui

Primary LLM chat interface (port 8080)

Proxied via Nginx

Integrates Ollama, SearXNG, local TTS, and Stable Diffusion image generation

Persistent storage: ../MarvinOS_Data/open-webui

openai-edge-tts

Local text-to-speech service (port 5050)

OpenAI-compatible speech API

searxng

Private meta-search engine for LLM grounding

Internal port 8080, optional debug access 8081

Persistent storage: ../MarvinOS_Data/searxng

stable-diffusion

Local image generation API using Automatic1111

GPU-accelerated

Port 7860, API accessible to Open WebUI

Persistent storage: ../MarvinOS_Data/stable-diffusion

🌐 Networks

default — Standard container connectivity

MarvinOSNET — Shared network for MarvinOS services

📁 Directory Layout

.
├── docker-compose.yml
├── Dockerfile.NginxConfig
├── Dockerfile.SearxngConfig
├── Dockerfile.pull-model
├── nginx/
│   ├── etc/
│   └── html/
├── searxng/
└── ../MarvinOS_Data/
    ├── nginx/
    ├── certs/
    ├── html/
    ├── ollama/
    ├── open-webui/
    ├── searxng/
    └── stable-diffusion/


🧰 Prerequisites

Linux host (recommended)

Docker 24+

Docker Compose v2

NVIDIA GPU (8GB+ recommended)

NVIDIA drivers + Container Toolkit installed

Verify GPU support:

docker run --rm --gpus all nvidia/cuda:12.2.0-base nvidia-smi


🚀 First-Time Setup

docker compose up --build


One-shot config containers run and exit

Model pull containers download models and exit

Access UI:

HTTP: http://localhost

HTTPS: https://localhost

Direct UI (debug): http://localhost:8080

🔁 Common Operations

Restart stack: docker compose restart

Stop stack: docker compose down

Pull additional models: docker compose up pull-llm-ollama-yourmodel

View logs:

docker compose logs -f open-webui
docker compose logs -f ollama
docker compose logs -f ingress


🔐 Security Notes

SSL certificates are self-signed by default

Open WebUI authentication is enabled

Replace placeholder secrets before exposure

SearXNG is intended for internal use

Not hardened for public internet exposure

🎯 Intended Use

Local AI experimentation

Secure internal LLM access

GPU-accelerated inference

MarvinOS development

Offline or air-gapped environments

📜 License / Attribution

Ollama — Apache 2.0

Open WebUI — MIT

Nginx — BSD-like

SearXNG — AGPLv3

Automatic1111 Stable Diffusion — GPL-compatible

This orchestration layer: use freely, modify freely