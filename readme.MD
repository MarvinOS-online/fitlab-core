MarvinOS Local AI Stack

A fully self-hosted, GPU-accelerated AI stack designed for local experimentation, secure internal use, offline environments, and MarvinOS development.

This stack combines:

Ollama (local LLM runtime)

Open WebUI (chat interface)

Nginx (TLS ingress)

SearXNG (private web search)

Local TTS (OpenAI-compatible)

One-shot configuration and model preloading jobs

Everything is Docker-based, reproducible, and designed to survive rebuilds without data loss.

ARCHITECTURE OVERVIEW

User
-> HTTPS (Nginx Ingress)
-> Open WebUI
-> Ollama (LLMs, GPU)
-> SearXNG (Web Search)
-> openai-edge-tts (Speech)

Persistent data lives outside the repo under ../MarvinOS_Data.

SERVICES

configure_ingress
One-shot container that copies curated Nginx configs and HTML assets, generates or installs SSL certificates, and writes everything into persistent volumes under MarvinOS_Data.
Runs once and exits.

configure_searxng
One-shot container that copies curated SearXNG configuration files into persistent storage under MarvinOS_Data/searxng.
Runs once and exits.

ingress (Nginx)
Acts as the public entry point.
Listens on ports 80 and 443.
Terminates TLS (self-signed by default).
Serves static HTML if present.
Proxies traffic to Open WebUI.
Includes a healthcheck using nginx -t.

ollama
Local GPU-accelerated LLM runtime.
Exposes port 11434.
Automatically binds to 0.0.0.0.
Uses NVIDIA GPUs.
Runtime tuned with Flash Attention, large context windows, GPU layer offload, and quantized KV cache.

Persistent storage:
../MarvinOS_Data/ollama

pull-llm-* model jobs
One-time model download containers.
Depend on Ollama.
Pre-download models into persistent storage.
Exit automatically when finished.
Safe to add, remove, or re-run.

Included model categories:
General purpose models
Visual reasoning models
Unlocked / abliterated models
Coding and embedding models

open-webui
Primary LLM chat interface.
Runs on port 8080 internally.
Proxied by Nginx for HTTPS access.
Authentication and signup enabled by default.
Connected directly to Ollama.
Integrated with SearXNG for web search and local TTS for speech output.

Persistent storage:
../MarvinOS_Data/open-webui

openai-edge-tts
Optional local text-to-speech service compatible with Open WebUI.
Runs on port 5050.
Does not require OpenAI cloud access.
Provides speech synthesis via a local OpenAI-compatible API.

searxng
Private meta-search engine used for LLM grounding.
Runs internally on port 8080.
Exposed on port 8081 for debugging if needed.
Configuration persists across rebuilds.

Persistent storage:
../MarvinOS_Data/searxng

NETWORKS

Two Docker bridge networks are used:

default
Standard container connectivity.

MarvinOSNET
Explicit shared network for MarvinOS services, allowing future isolation or security tightening without redesign.

DIRECTORY LAYOUT

.
├── docker-compose.yml
├── Dockerfile.NginxConfig
├── Dockerfile.SearxngConfig
├── Dockerfile.pull-model
├── nginx/
│ ├── etc/
│ └── html/
├── searxng/
└── ../MarvinOS_Data/
├── nginx/
├── certs/
├── html/
├── ollama/
├── open-webui/
└── searxng/

Important: MarvinOS_Data lives outside the repo to preserve data across rebuilds.

PREREQUISITES

Linux host recommended

Docker 24+

Docker Compose v2

NVIDIA GPU (8GB+ recommended)

NVIDIA drivers installed

NVIDIA Container Toolkit installed

Verify GPU support:

docker run --rm --gpus all nvidia/cuda:12.2.0-base nvidia-smi

FIRST-TIME SETUP

Build and start everything

docker compose up --build

Wait for model pulls to complete

Model pull containers will exit automatically when finished.

Access the UI

HTTP: http://localhost

HTTPS: https://localhost

Direct UI (debug): http://localhost:8080

COMMON OPERATIONS

Restart the stack
docker compose restart

Stop everything
docker compose down

Pull additional models
Add a new pull-llm-* service and run:
docker compose up pull-llm-ollama-yourmodel

View logs
docker compose logs -f open-webui
docker compose logs -f ollama
docker compose logs -f ingress

SECURITY NOTES

SSL certificates are self-signed by default

Open WebUI authentication is enabled

Replace all placeholder secrets before exposure

SearXNG is intended for internal use

This stack is not hardened for public internet exposure

INTENDED USE

This stack is ideal for:

Local AI experimentation

Secure internal LLM access

GPU-accelerated inference

MarvinOS development and integration

Offline or air-gapped environments

LICENSE / ATTRIBUTION

Ollama: Apache 2.0
Open WebUI: MIT
Nginx: BSD-like
SearXNG: AGPLv3
This orchestration: use freely, modify freely