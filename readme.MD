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

Retrieval-Augmented Generation (RAG) with vector database

Local document ingestion + semantic search

One-shot configuration containers

Persistent data stored outside the repository

🧠 Stack Components

Ollama — Local LLM runtime + embedding engine (GPU accelerated)

Open WebUI — Chat interface + RAG orchestration

Qdrant — Vector database for embeddings (RAG)

Nginx — TLS ingress + reverse proxy

SearXNG — Private meta-search engine

openai-edge-tts — Local OpenAI-compatible TTS

Stable Diffusion (Automatic1111) — Local image generation API

🧠 RAG (Retrieval-Augmented Generation)

This stack includes a fully local RAG pipeline with no external dependencies.

RAG Flow

Documents are uploaded via Open WebUI

Text is embedded locally using Ollama

Embeddings are stored in Qdrant

Relevant context is retrieved per query

Context is injected into the LLM prompt

Responses include citations

RAG Configuration

Vector DB: Qdrant

Embedding Engine: Ollama

Embedding Model: nomic-embed-text:v1.5

Citations: Enabled

Persistence: Disk-backed, rebuild-safe

This supports:

Local knowledge bases

Long-lived document memory

Offline / air-gapped environments

Secure internal data

🏗 Architecture Overview
User
 └─ HTTPS (Nginx Ingress)
     └─ Open WebUI
         ├─ Ollama (LLMs + Embeddings, GPU)
         ├─ Qdrant (Vector DB / RAG)
         ├─ Stable Diffusion API
         ├─ SearXNG (Web Search)
         └─ openai-edge-tts (Speech)


Persistent data is stored outside the repository under:

../MarvinOS_Data

📦 Services
configure_ingress

One-shot container

Copies curated Nginx configs and HTML assets

Generates or installs SSL certificates

Writes into persistent volumes

Runs once and exits

configure_searxng

One-shot container

Copies curated SearXNG configuration

Runs once and exits

ingress (Nginx)

Public entry point (ports 80 / 443)

Terminates TLS (self-signed by default)

Proxies traffic to Open WebUI

Healthcheck via nginx -t

ollama

Local GPU-accelerated LLM runtime

Used for:

Chat inference

RAG embeddings

Port: 11434

Persistent storage: ../MarvinOS_Data/ollama

Tuned via environment variables per GPU type

open-webui

Primary chat + RAG interface

Port: 8080

Proxied via Nginx

Integrates:

Ollama

Qdrant

SearXNG

Stable Diffusion

Local TTS

Persistent storage: ../MarvinOS_Data/open-webui

qdrant

Vector database for RAG

Port: 6333

API-key protected

Persistent storage: ../MarvinOS_Data/qdrant

openai-edge-tts

Local OpenAI-compatible text-to-speech

Port: 5050

searxng

Private meta-search engine

Internal port: 8080

Optional debug access: 8081

Persistent storage: ../MarvinOS_Data/searxng

stable-diffusion

Automatic1111-based image generation API

GPU-accelerated

Port: 7860

Persistent storage: ../MarvinOS_Data/stable-diffusion

🌐 Networks

default — Standard Docker bridge

MarvinOSNET — Internal MarvinOS service network

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
    ├── qdrant/
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

Services start automatically

Data persists across rebuilds

Access Points

HTTP: http://localhost

HTTPS: https://localhost

Direct UI (debug): http://localhost:8080

🔁 Common Operations
Restart stack
docker compose restart

Stop stack
docker compose down

📥 Pulling Additional Ollama Models

All models are managed inside the running Ollama container.

Pull a Model
docker compose exec ollama ollama pull llama3.2:3b


Examples:

docker compose exec ollama ollama pull mistral:7b
docker compose exec ollama ollama pull qwen2.5:7b
docker compose exec ollama ollama pull nomic-embed-text:v1.5


Models are stored in:

../MarvinOS_Data/ollama

List Installed Models
docker compose exec ollama ollama list

Remove a Model
docker compose exec ollama ollama rm model-name

🔐 Security Notes

SSL certificates are self-signed by default

Open WebUI authentication is enabled

Replace placeholder secrets before exposure

Qdrant is API-key protected but internal-only

SearXNG is intended for private use

Not hardened for public internet exposure

🎯 Intended Use

Local AI experimentation

Secure internal LLM access

GPU-accelerated inference

Local RAG knowledge bases

MarvinOS development

Offline / air-gapped environments

📜 License / Attribution

Ollama — Apache 2.0

Open WebUI — MIT

Nginx — BSD-like

SearXNG — AGPLv3

Qdrant — Apache 2.0

Automatic1111 Stable Diffusion — GPL-compatible

This orchestration layer: use freely, modify freely