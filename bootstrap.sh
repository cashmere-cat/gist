#!/bin/bash

if [ -z "$1" ]; then
  echo "Usage: $0 <GitHub PAT Token>"
  exit 1
fi

GITHUB_TOKEN=$1
REPO_URL="https://github.com/cashmere-cat/infra.git"

echo "Installing git, curl, and unzip..."
sudo apt update
sudo apt install -y git curl unzip

echo "Installing Bun..."
curl -fsSL https://bun.sh/install | bash
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

echo "Cloning repository from $REPO_URL..."
git clone "https://$GITHUB_TOKEN@${REPO_URL#https://}"
REPO_NAME=$(basename "$REPO_URL" .git)

cd "$REPO_NAME" || { echo "Failed to enter repository directory"; exit 1; }

echo "Running script with Bun..."
bun run scripts/bootstrap/bootstrap.ts 
