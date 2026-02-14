MarvinOS Local AI Stack

A fully self-hosted, GPU-accelerated AI stack designed for local experimentation, secure internal use, offline environments, and MarvinOS development.

This stack is Docker-based, reproducible, and designed to survive rebuilds without data loss.

⚠️ Intended for Home / Lab Use Only — not hardened for public internet production.

🚀 Features

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

Fully local RAG pipeline with zero external dependencies:

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

🔐 Secrets & Setup
Automatic Secrets

setup.sh now handles all secret generation automatically.

You no longer need to create a .env manually — keys like:

WEBUI_SECRET_KEY
QDRANT__SERVICE__API_KEY
AUTOMATIC1111_API_AUTH
AUDIO_TTS_OPENAI_API_KEY


are generated securely during setup.

Certificates

You still need to provide valid TLS certificates for HTTPS.

Place them in:

../MarvinOS_Data/certs


Self-signed certs are fine for local/lab use.

For production or internet-facing environments, use proper certificates and firewall restrictions.

setup.sh
#!/usr/bin/env bash
set -e
export HOST_UID=$(id -u)
export HOST_GID=$(id -g)
mkdir -p ../MarvinOS_Data
docker compose run --rm configure_env
docker compose up -d
docker compose logs -f


What it does:

Creates ../MarvinOS_Data if missing

Generates secure .env file

Runs one-shot configuration containers

Starts the full stack with GPU-safe permissions

Tails logs automatically

Usage:

./setup.sh

📦 Prerequisites

Linux host (recommended)

Docker 24+

Docker Compose v2

NVIDIA GPU (8GB+ recommended)

NVIDIA drivers + Container Toolkit

Verify GPU access:

docker run --rm --gpus all nvidia/cuda:12.2.0-base nvidia-smi

🔁 Operations

Restart services:

docker compose restart


Stop services:

docker compose down

📥 Managing Ollama Models

Pull a model:

docker compose exec ollama ollama pull llama3.2:3b
docker compose exec ollama ollama pull mistral:7b
docker compose exec ollama ollama pull qwen2.5:7b
docker compose exec ollama ollama pull nomic-embed-text:v1.5


List installed models:

docker compose exec ollama ollama list


Remove a model:

docker compose exec ollama ollama rm <model-name>


Models are stored in:

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

Orchestration layer — free to use and modify