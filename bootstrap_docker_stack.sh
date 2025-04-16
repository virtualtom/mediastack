#!/bin/bash

# === Configuration ===
REPO_URL="git@github.com:virtualtom/arrstack.git"
REPO_NAME="arrstack"
TARGET_DIR="/opt/docker"
DOCKER_USER="dockeruser"
DOCKER_GROUP="docker"
ENV_FILE=".env"

# === Ensure running as root ===
if [ "$EUID" -ne 0 ]; then
  echo "❌ Please run this script with sudo or as root."
  exit 1
fi

# === Install Docker if not present ===
if ! command -v docker &> /dev/null; then
    echo "📦 Docker not found. Installing Docker..."
    apt-get update
    apt-get install -y ca-certificates curl gnupg lsb-release
    mkdir -p /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    echo       "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian       $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
    apt-get update
    apt-get install -y docker-ce docker-ce-cli containerd.io
    echo "✅ Docker installed successfully."
else
    echo "✅ Docker already installed."
fi

# === Install Docker Compose if not present ===
if ! command -v docker-compose &> /dev/null; then
    echo "📦 Docker Compose not found. Installing Docker Compose..."
    COMPOSE_VERSION="1.29.2"
    curl -L "https://github.com/docker/compose/releases/download/${COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose
    ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
    echo "✅ Docker Compose installed successfully."
else
    echo "✅ Docker Compose already installed."
fi

# === Check SSH access to GitHub as dockeruser ===
echo "🔐 Checking SSH connectivity to GitHub (as $DOCKER_USER)..."
SSH_TEST=$(sudo -u "$DOCKER_USER" ssh -T git@github.com 2>&1)

if echo "$SSH_TEST" | grep -qi "successfully authenticated"; then
    echo "✅ SSH to GitHub works."
else
    echo "❌ SSH to GitHub failed."
    echo "💬 Output: $SSH_TEST"
    exit 1
fi

# === Create base directory ===
echo "📁 Ensuring $TARGET_DIR exists..."
mkdir -p "$TARGET_DIR"
chown "$DOCKER_USER:$DOCKER_GROUP" "$TARGET_DIR"

# === Clone or update repo ===
cd "$TARGET_DIR"

if [ -d "$REPO_NAME/.git" ]; then
    echo "🔄 Repo already exists. Pulling latest changes..."
    cd "$REPO_NAME"
    git pull origin main
else
    echo "⬇️ Cloning repo into $TARGET_DIR/$REPO_NAME..."
    sudo -u "$DOCKER_USER" git clone "$REPO_URL"
    cd "$REPO_NAME"
fi

# === Set ownership again after pull/clone ===
echo "🔐 Fixing permissions..."
chown -R "$DOCKER_USER:$DOCKER_GROUP" .

# === Run directory setup script ===
if [ -f "arrstack/setup_docker_dirs.sh" ]; then
    echo "🛠 Running setup_docker_dirs.sh..."
    bash arrstack/setup_docker_dirs.sh
else
    echo "⚠️ setup_docker_dirs.sh not found in arrstack/"
fi

# === Get UID/GID and write to .env ===
DOCKER_UID=$(id -u "$DOCKER_USER")
DOCKER_GID=$(id -g "$DOCKER_USER")

echo "📄 Generating .env file with UID and GID..."
cat > "$ENV_FILE" <<EOF
# Generated automatically by bootstrap_docker_stack.sh

PUID=$DOCKER_UID
PGID=$DOCKER_GID
TZ=America/New_York
EOF

echo "✅ Repo ready at $TARGET_DIR/$REPO_NAME"
echo "👤 Docker user UID (PUID): $DOCKER_UID"
echo "👥 Docker group GID (PGID): $DOCKER_GID"
echo "📋 .env file created with updated values. Use \${PUID} and \${PGID} in your docker-compose.yml files."