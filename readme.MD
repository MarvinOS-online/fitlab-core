MarvinOS Local AI Stack

A fully self-hosted, GPU-accelerated AI stack designed for local experimentation, secure internal use, offline environments, and MarvinOS development.

This stack is Docker-based, reproducible, and designed to survive rebuilds without data loss.

⚠️ Intended for Home / Lab Use Only

This project is designed for:

Local experimentation
Private internal environments
Air-gapped systems
Development use

It is NOT hardened for public internet production exposure.

Before deploying in any production or internet-accessible environment, you must:

Replace all default secrets
Use proper certificate management
Implement firewall restrictions
Use a dedicated secret manager
Perform security review and hardening
You are responsible for securing your deployment.

✨ Features

Fully local LLM inference (no cloud dependency)
GPU-accelerated (NVIDIA)
HTTPS ingress with Nginx
Web-based chat UI (Open WebUI)
Private web search grounding (SearXNG)
Local OpenAI-compatible TTS
Stable Diffusion image generation (local GPU)
Retrieval-Augmented Generation (RAG)
Local document ingestion + semantic search
Persistent data outside the repository
Reproducible containerized deployment

🧠 Core Stack

Ollama — LLM runtime + embeddings (GPU accelerated)
Open WebUI — Chat interface + RAG orchestration
Qdrant — Vector database
Nginx — TLS ingress + reverse proxy
SearXNG — Private meta-search
openai-edge-tts — Local OpenAI-compatible TTS
Stable Diffusion (Automatic1111) — Local image generation API

🧠 RAG Architecture

Fully local RAG pipeline with zero external dependencies.

Flow:

Documents uploaded via Open WebUI
Text embedded locally via Ollama
Embeddings stored in Qdrant
Relevant context retrieved per query
Context injected into prompt
Citations returned in response

Configuration:

Vector DB: Qdrant
Embedding Engine: Ollama
Embedding Model: nomic-embed-text:v1.5
Persistence: Disk-backed

Supports:
Secure internal knowledge bases
Offline environments
Long-lived document memory

🏗 Architecture Overview

User
└─ HTTPS (Nginx)
└─ Open WebUI
  ├─ Ollama (LLM + Embeddings, GPU)
  ├─ Qdrant (Vector DB)
  ├─ Stable Diffusion API
  ├─ SearXNG
  └─ openai-edge-tts

Persistent data stored in:

../MarvinOS_Data

🔐 Secrets & Key Management

⚠️ Default secrets are placeholders and must be replaced before exposing this stack beyond local use.

The following values should be changed:

WEBUI_SECRET_KEY
QDRANT__SERVICE__API_KEY
AUTOMATIC1111_API_AUTH
AUDIO_TTS_OPENAI_API_KEY

Any default passwords or auth strings

Generating Secure Keys
Generate a strong 32-byte key:

Linux/macOS:

openssl rand -base64 32

Alternative:

head -c 32 /dev/urandom | base64

Recommended: Use a .env File

Create a file:

.env


Example:

WEBUI_SECRET_KEY=replace_with_random_value
QDRANT_API_KEY=replace_with_random_value
STABLE_DIFFUSION_AUTH=username:strongpassword

Update docker-compose.yml to reference variables:

WEBUI_SECRET_KEY=${WEBUI_SECRET_KEY}

Add to .gitignore:
.env


Do not commit secrets to source control.
📦 Prerequisites

Linux host (recommended)
Docker 24+
Docker Compose v2
NVIDIA GPU (8GB+ recommended)
NVIDIA drivers + Container Toolkit

Verify GPU access:

docker run --rm --gpus all nvidia/cuda:12.2.0-base nvidia-smi

🚀 First-Time Setup
docker compose up --build

One-shot configuration containers execute

Services start automatically
Data persists across rebuilds

Access:

http://localhost

https://localhost

Debug UI: http://localhost:8080

🔁 Operations

Restart:
docker compose restart


Stop:
docker compose down

📥 Managing Ollama Models

Pull a model:
docker compose exec ollama ollama pull llama3.2:3b


Examples:
docker compose exec ollama ollama pull mistral:7b
docker compose exec ollama ollama pull qwen2.5:7b
docker compose exec ollama ollama pull nomic-embed-text:v1.5


List installed models:
docker compose exec ollama ollama list


Remove a model:
docker compose exec ollama ollama rm model-name

Models stored in:

../MarvinOS_Data/ollama

🌐 Networks

default — Docker bridge

MarvinOSNET — Internal service network

🎯 Intended Use Cases
Local AI experimentation
Secure internal LLM access
GPU-accelerated inference
Offline RAG knowledge bases
MarvinOS development
Air-gapped deployments

📜 License

Component licenses apply individually:

Ollama — Apache 2.0
Open WebUI — MIT
Nginx — BSD-like
SearXNG — AGPLv3
Qdrant — Apache 2.0
Automatic1111 — GPL-compatible
Orchestration layer: free to use and modify.
