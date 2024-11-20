#!/bin/bash

sudo apt update
sudo apt install -y git curl unzip

if [ -z "$1" ]; then
  exit 1
fi

GITHUB_TOKEN=$1
REPO_URL="https://github.com/cashmere-cat/infra.git"
REPO_NAME=$(basename "$REPO_URL" .git)

curl -fsSL https://bun.sh/install | bash

git clone "https://x-access-token:$GITHUB_TOKEN@${REPO_URL#https://}" $REPO_NAME

cd "$REPO_NAME" || { echo "Failed to enter repository directory"; exit 1; }

bun run scripts/bootstrap/bootstrap.ts 
