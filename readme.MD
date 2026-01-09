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

One-shot configuration + model preload jobs

Persistent data stored outside the repo

🧠 Stack Components

Ollama — Local LLM runtime (GPU accelerated)

Open WebUI — Chat interface

Nginx — TLS ingress + reverse proxy

SearXNG — Private meta-search engine

openai-edge-tts — Local OpenAI-compatible TTS

One-shot config & model pull containers

🏗 Architecture Overview
User
 └─ HTTPS (Nginx Ingress)
     └─ Open WebUI
         ├─ Ollama (LLMs, GPU)
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

Public entry point

Listens on 80 / 443

Terminates TLS (self-signed by default)

Serves static HTML if present

Proxies traffic to Open WebUI

Healthcheck via nginx -t

ollama

Local GPU-accelerated LLM runtime.

Exposes port 11434

Binds to 0.0.0.0

Uses NVIDIA GPUs

Runtime tuned via environment variables

Persistent storage:

../MarvinOS_Data/ollama

🔧 GPU-SPECIFIC OLLAMA CONFIGURATION (IMPORTANT)

Ollama behavior depends heavily on GPU architecture.

This stack defaults to modern NVIDIA GPUs (RTX / Ampere / Ada).
Tesla P100 (Pascal) is explicitly opt-in.

⚠️ Only one configuration block must be active at a time.

✅ Default Configuration — Modern NVIDIA GPUs (RTX / Ampere / Ada)

This configuration is enabled by default.

Use this for:

RTX 20xx / 30xx / 40xx

A4000 / A5000 / A6000

L4, L40, A10, A100

Any GPU with Tensor Cores and Flash Attention support

environment:
  - OLLAMA_HOST=0.0.0.0
  - OLLAMA_NUM_CTX=32768

  # Modern GPU defaults
  - OLLAMA_FLASH_ATTENTION=1
  - OLLAMA_KV_CACHE_TYPE=q4_0
  - OLLAMA_GPU_LAYERS=40

Why this is the default

Flash Attention is fully supported and faster

Quantized KV cache reduces VRAM usage

Fixed GPU layer offload improves predictability

Tensor Cores are utilized effectively

Best overall performance on modern hardware

✅ Leave this enabled unless you are explicitly using a Tesla P100

⚠️ Legacy Configuration — Tesla P100 (Pascal Architecture)

Not enabled by default.

Enable this only if you are using:

Tesla P100-PCIE-12GB

Other Pascal-generation GPUs without Tensor Cores

Step 1: Comment out the modern GPU block
# - OLLAMA_FLASH_ATTENTION=1
# - OLLAMA_KV_CACHE_TYPE=q4_0
# - OLLAMA_GPU_LAYERS=40

Step 2: Uncomment the Tesla P100 block
  # Tesla P100 ONLY (Pascal)
  - OLLAMA_FLASH_ATTENTION=0
  - OLLAMA_KV_CACHE_TYPE=f16
  - OLLAMA_GPU_LAYERS=-1

Why this configuration exists

Pascal GPUs lack Tensor Cores

Flash Attention provides little or no benefit

FP16 KV cache outperforms quantized caches

Automatic GPU layer placement avoids CPU fallback

12GB VRAM constraint requires careful tuning

⚠️ Do not use this configuration on modern GPUs

🔍 Verifying GPU Acceleration

Check Ollama logs:

docker compose logs -f ollama


You should see:

CUDA initialization messages

No CPU fallback warnings

Stable VRAM usage

Verify GPU visibility:

docker run --rm --gpus all nvidia/cuda:12.2.0-base nvidia-smi

pull-llm-* (Model Jobs)

One-shot model download containers

Depend on Ollama

Preload models into persistent storage

Exit automatically when finished

Safe to re-run or remove

Included model categories:

General-purpose LLMs

Visual reasoning models

Unlocked / abliterated models

Coding models

Embedding models

open-webui

Primary LLM chat interface.

Runs internally on port 8080

Proxied via Nginx for HTTPS

Authentication enabled by default

Connected to Ollama

Integrated with SearXNG and local TTS

Persistent storage:

../MarvinOS_Data/open-webui

openai-edge-tts

Optional local text-to-speech service.

Runs on port 5050

No OpenAI cloud access required

OpenAI-compatible speech API

searxng

Private meta-search engine for LLM grounding.

Internal port 8080

Optional debug access on 8081

Configuration persists across rebuilds

Persistent storage:

../MarvinOS_Data/searxng

🌐 Networks

Two Docker bridge networks are used:

default — Standard container connectivity

MarvinOSNET — Explicit shared network for MarvinOS services

This allows future isolation or security tightening without redesign.

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
    └── searxng/


⚠️ Important: MarvinOS_Data lives outside the repo to preserve data across rebuilds.

🧰 Prerequisites

Linux host (recommended)

Docker 24+

Docker Compose v2

NVIDIA GPU (8GB+ recommended)

NVIDIA drivers installed

NVIDIA Container Toolkit installed

Verify GPU support:

docker run --rm --gpus all nvidia/cuda:12.2.0-base nvidia-smi

🚀 First-Time Setup
Build and start everything
docker compose up --build


One-shot config containers will run and exit

Model pull containers will download models and exit automatically

Access the UI

HTTP: http://localhost

HTTPS: https://localhost

Direct UI (debug): http://localhost:8080

🔁 Common Operations
Restart the stack
docker compose restart

Stop everything
docker compose down

Pull additional models
docker compose up pull-llm-ollama-yourmodel

View logs
docker compose logs -f open-webui
docker compose logs -f ollama
docker compose logs -f ingress

🔐 Security Notes

SSL certificates are self-signed by default

Open WebUI authentication is enabled

Replace all placeholder secrets before exposure

SearXNG is intended for internal use

Not hardened for public internet exposure

🎯 Intended Use

This stack is ideal for:

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

This orchestration layer: use freely, modify freely.