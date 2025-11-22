#!/bin/bash
# Fail on error
set -euo pipefail

# Change to the repository root directory
cd "$(dirname "$0")"/..

OUTPUT_DIR="packer/outputs"
OUTPUT_NAME="archlinux-ansible"
IMAGE_REF="pluggero/docker-archlinux-ansible"
IMAGE_TAG="$(date +%Y.%m.%d)"

# Initialize Packer
packer init packer/

# Run the Packer build
packer build -force -on-error=ask packer/

# Create output directory
mkdir -p "${OUTPUT_DIR}"

# Export the Docker image to a tar file
OUTPUT_FILE="${OUTPUT_DIR}/${OUTPUT_NAME}.tar"
echo "Exporting image to ${OUTPUT_FILE}..."
docker save -o "${OUTPUT_FILE}" "${IMAGE_REF}:${IMAGE_TAG}"

# Create version.txt with commit hash
COMMIT_HASH=$(git rev-parse HEAD 2>/dev/null || echo "unknown")
echo "$COMMIT_HASH" > "${OUTPUT_DIR}/version.txt"

echo "Build completed: ${OUTPUT_FILE}"
