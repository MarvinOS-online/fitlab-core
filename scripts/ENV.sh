#!/usr/bin/env bash
set -e

ENV_FILE="/data/.env"

echo "=== MarvinOS Secure Environment Generator ==="

if [ -f "$ENV_FILE" ]; then
  echo ".env already exists."
  echo "Refusing to overwrite."
  exit 0
fi

generate_secret() {
  openssl rand -hex 32
}

echo "Generating cryptographic secrets..."

WEBUI_SECRET_KEY=$(generate_secret)
QDRANT_API_KEY=$(generate_secret)
SD_API_PASSWORD=$(generate_secret)
OPENEDAI_API_KEY=$(generate_secret)

cat > "$ENV_FILE" <<EOF
# ==========================================
# MarvinOS Environment File
# Generated: $(date)
# ==========================================

WEBUI_SECRET_KEY=${WEBUI_SECRET_KEY}
QDRANT_API_KEY=${QDRANT_API_KEY}
SD_API_PASSWORD=${SD_API_PASSWORD}
OPENEDAI_API_KEY=${OPENEDAI_API_KEY}

EOF

chmod 600 "$ENV_FILE"

echo ""
echo ".env created at $ENV_FILE"
echo "Permissions set to 600"
echo ""