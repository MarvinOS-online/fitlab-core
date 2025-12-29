#!/bin/sh

# Check if model name is provided
if [ -z "$1" ]; then
    echo "Error: Model name not provided"
    echo "Usage: $0 <model_name>"
    exit 1
fi

MODEL_NAME=$1

# Install required tools
apk add --no-cache curl

# Wait for Ollama service
echo "Waiting for ollama service to be ready..."
until curl -s -f "http://ollama:11434/api/tags" > /dev/null 2>&1; do
    echo "Waiting for ollama service..."
    sleep 15
done

# Check if model exists
echo "Checking if model exists..."
MODELS=$(curl -s http://ollama:11434/api/tags)
echo "=== Currently Installed Models ==="
echo "$MODELS" | grep -o '"name":"[^"]*"' | cut -d'"' -f4 | sort | while read model; do
  if [ "$model" = "$MODEL_NAME:latest" ]; then
    echo "* $model  <-- Target Model"
  else
    echo "  $model"
  fi
done
echo "================================"

if echo "$MODELS" | grep -q "\"name\":\"$MODEL_NAME:latest\""
then
    echo "$MODEL_NAME model already exists, exiting."
    exit 0
else
    echo "Ollama service detected, pulling model..."
    START_TIME=$(date +%s)
    curl -f -X POST http://ollama:11434/api/pull -d "{\"name\":\"$MODEL_NAME\"}" | while read -r line; do
        if echo "$line" | grep -q "\"total\":" && echo "$line" | grep -q "\"completed\":"; then
            total=$(echo "$line" | grep -o '"total":[0-9]*' | cut -d':' -f2)
            completed=$(echo "$line" | grep -o '"completed":[0-9]*' | cut -d':' -f2)
            percent=$((completed * 100 / total))
            current_time=$(date +%s)
            elapsed=$((current_time - START_TIME))
            
            if [ $completed -eq $total ]; then
                rate=$((total / elapsed))
                echo -ne "\rDownload: [100%] $((total/1024/1024))MB Complete. Avg speed: $((rate/1024/1024))MB/s     \n"
            else
                if [ $elapsed -gt 0 ]; then
                    rate=$((completed / elapsed))
                    eta=$(((total - completed) / rate))
                    echo -ne "\rDownload: [$percent%] $((completed/1024/1024))MB of $((total/1024/1024))MB | ETA: ${eta}s     "
                fi
            fi
        elif echo "$line" | grep -q "\"status\":"; then
            status=$(echo "$line" | grep -o '"status":"[^"]*"' | cut -d'"' -f4)
            if [ "$status" != "downloading" ]; then
                echo -ne "\r$status...                                                                \n"
            fi
        fi
    done
    PULL_STATUS=$?
    echo "Pull status: $PULL_STATUS"
    
    # Check if the model is now in the list of models
    MODELS_AFTER=$(curl -s http://ollama:11434/api/tags)
    echo "Checking if $MODEL_NAME exists in updated model list..."
    if [ $PULL_STATUS -eq 0 ] && echo "$MODELS_AFTER" | grep -q "\"name\":\"$MODEL_NAME:latest\""; then
        echo "Successfully pulled $MODEL_NAME"
        exit 0
    else
        echo "!!! WARNING !!!"
        echo "Failed to pull model: $MODEL_NAME"
        echo "This model may not be available or there might be connection issues."
        echo "!!!!!!!!!!!!!!!"
        exit 1
    fi
fi 