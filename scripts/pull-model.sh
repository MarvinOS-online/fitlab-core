#!/bin/sh

MODELS_FILE="/usr/local/bin/OllamaModels.txt"

# Ensure models file exists
if [ ! -f "$MODELS_FILE" ]; then
    echo "Error: $MODELS_FILE not found"
fi

# Install required tools
apk add --no-cache curl

# Wait for Ollama service
echo "Waiting for ollama service to be ready..."
until curl -s -f "http://ollama:11434/api/tags" > /dev/null 2>&1; do
    echo "Waiting for ollama service..."
    sleep 15
done

# Process each model
while IFS= read -r MODEL_NAME || [ -n "$MODEL_NAME" ]; do
    # Skip empty lines and comments
    case "$MODEL_NAME" in
        ""|\#*) continue ;;
    esac

    echo ""
    echo "============================================"
    echo "Processing model: $MODEL_NAME"
    echo "============================================"

    MODELS=$(curl -s http://ollama:11434/api/tags)

    if echo "$MODELS" | grep -q "\"name\":\"$MODEL_NAME:latest\""; then
        echo "$MODEL_NAME already exists, skipping."
        continue
    fi

    echo "Pulling model: $MODEL_NAME"
    START_TIME=$(date +%s)

    curl -f -X POST http://ollama:11434/api/pull \
        -d "{\"name\":\"$MODEL_NAME\"}" |
    while read -r line; do
        if echo "$line" | grep -q "\"total\":" && echo "$line" | grep -q "\"completed\":"; then
            total=$(echo "$line" | grep -o '"total":[0-9]*' | cut -d':' -f2)
            completed=$(echo "$line" | grep -o '"completed":[0-9]*' | cut -d':' -f2)

            if [ "$total" -gt 0 ]; then
                percent=$((completed * 100 / total))
            else
                percent=0
            fi

            current_time=$(date +%s)
            elapsed=$((current_time - START_TIME))

            if [ "$completed" -eq "$total" ]; then
                rate=$((elapsed > 0 ? total / elapsed : 0))
                echo -ne "\rDownload: [100%] $((total/1024/1024))MB complete. Avg speed: $((rate/1024/1024))MB/s\n"
            else
                if [ "$elapsed" -gt 0 ]; then
                    rate=$((completed / elapsed))
                    eta=$((rate > 0 ? (total - completed) / rate : 0))
                    echo -ne "\rDownload: [$percent%] $((completed/1024/1024))MB of $((total/1024/1024))MB | ETA: ${eta}s     "
                fi
            fi

        elif echo "$line" | grep -q "\"status\":"; then
            status=$(echo "$line" | grep -o '"status":"[^"]*"' | cut -d'"' -f4)
            [ "$status" != "downloading" ] && echo -ne "\r$status...\n"
        fi
    done

    echo "Finished processing: $MODEL_NAME"

done < "$MODELS_FILE"

echo ""
echo "All models processed."
