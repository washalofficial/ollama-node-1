#!/bin/bash
echo "🚀 Setting up Ollama Server..."

# Update system
sudo apt update && sudo apt upgrade -y

# Install dependencies
sudo apt install -y zstd curl wget git

# Install Ollama
curl -fsSL https://ollama.com/install.sh | sh

# Install cloudflared
wget https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64
chmod +x cloudflared-linux-amd64
sudo mv cloudflared-linux-amd64 /usr/local/bin/cloudflared

# Start Ollama
ollama serve &
sleep 10

# Download Qwen Coder (default model)
ollama pull qwen2.5-coder:7b

# Create keep-alive script
cat > ~/keep-alive.sh << 'EOF'
#!/bin/bash
while true; do
  curl -s http://localhost:11434/api/tags > /dev/null
  echo "$(date): Ollama active" >> ~/ollama.log
  sleep 300
done
EOF

chmod +x ~/keep-alive.sh
nohup ~/keep-alive.sh &

# Create health check endpoint
cat > ~/health.sh << 'EOF'
#!/bin/bash
while true; do
  echo '{"status":"active","model":"qwen2.5-coder:7b"}' > ~/health.json
  sleep 60
done
EOF

chmod +x ~/health.sh
nohup ~/health.sh &

echo "✅ Setup complete! Ollama is running"
echo "📝 Use: curl http://localhost:11434/api/tags to verify"