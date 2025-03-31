#!/bin/zsh

set -e  # Stop on errors

# === Docker Desktop Check & Auto-Start ===
echo "🧪 Checking Docker Desktop..."

if ! command -v docker &>/dev/null; then
  echo "❌ Docker CLI not found. Is Docker Desktop installed?"
  exit 1
fi

if ! docker info &>/dev/null; then
  echo "🚀 Docker is not running. Starting Docker Desktop..."
  open -a Docker

  # Wait for Docker to become available
  echo -n "⏳ Waiting for Docker to start"
  while ! docker info &>/dev/null; do
    echo -n "."
    sleep 1
  done
  echo ""
  echo "✅ Docker is now running"
else
  echo "✅ Docker is running"
fi

# === Configuration ===
MODULE_NAME="your-project-webapp"
FINAL_NAME="magnolia-webapp"
WAR_FILE="$MODULE_NAME/target/$FINAL_NAME.war"
DOCKERFILE="$MODULE_NAME/Dockerfile"
LOCAL_IMAGE_NAME="magnolia-webapp"
ACR_IMAGE_NAME="yourname.azurecr.io/magnolia-webapp:latest"

# === Determine mode (default: local build) ===
if [[ "$1" == "acr" ]]; then
  echo "☁️  Azure ACR-compatible build (linux/amd64)"
  IMAGE_NAME=$ACR_IMAGE_NAME
  BUILD_COMMAND="docker buildx build \
    --platform linux/amd64 \
    -f $DOCKERFILE \
    -t $IMAGE_NAME \
    --load \
    ."
else
  echo "🛠️  Local build"
  IMAGE_NAME=$LOCAL_IMAGE_NAME
  BUILD_COMMAND="docker build \
    -f $DOCKERFILE \
    -t $IMAGE_NAME \
    ."
fi

# === Build WAR ===
echo "🔨 Building WAR..."
mvn clean package -DskipTests -pl $MODULE_NAME

if [[ ! -f "$WAR_FILE" ]]; then
  echo "❌ Could not find WAR file: $WAR_FILE"
  exit 1
fi

# === Build Docker Image ===
echo "🐳 Building Docker image: $IMAGE_NAME"
eval $BUILD_COMMAND

echo "✅ Build complete: $IMAGE_NAME"