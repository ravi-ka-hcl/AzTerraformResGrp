
#!/usr/bin/env bash
set -euo pipefail

# ==============================================
# Ubuntu Installer for Terraform Artifactory Backend Plugin
# Usage:
#   ./install-artifactory-backend-ubuntu.sh 1.0.4
# ==============================================

# Version input or default
VERSION="${1:-1.0.4}"
NAMESPACE="jfrog"
NAME="artifactory"

# Detect architecture
ARCH=$(uname -m)
if [[ "$ARCH" == "x86_64" ]]; then
    OS_ARCH="linux_amd64"
elif [[ "$ARCH" == "aarch64" ]] || [[ "$ARCH" == "arm64" ]]; then
    OS_ARCH="linux_arm64"
else
    echo "❌ Unsupported architecture: $ARCH"
    echo "Supported: x86_64, arm64"
    exit 1
fi

# Build paths
PLUGIN_ROOT="$HOME/.terraform.d/plugins/registry.terraform.io/${NAMESPACE}/${NAME}/${VERSION}/${OS_ARCH}"
ZIP_NAME="terraform-backend-artifactory_${VERSION}_${OS_ARCH}.zip"
DOWNLOAD_URL="https://github.com/jfrog/terraform-backend-artifactory/releases/download/v${VERSION}/${ZIP_NAME}"

echo "=============================================="
echo " Installing Terraform Artifactory Backend"
echo " Version: ${VERSION}"
echo " Platform: ${OS_ARCH}"
echo " Download: ${DOWNLOAD_URL}"
echo "=============================================="

# Ensure required tools exist
for cmd in curl unzip; do
    if ! command -v $cmd >/dev/null 2>&1; then
        echo "❌ Missing required command: $cmd"
        echo "Installing with: sudo apt install -y $cmd"
        sudo apt update && sudo apt install -y $cmd
    fi
done

# Create target directory
mkdir -p "${PLUGIN_ROOT}"

# Download ZIP
TMP_DIR=$(mktemp -d)
ZIP_PATH="${TMP_DIR}/${ZIP_NAME}"

echo "⬇ Downloading plugin..."
curl -L -o "${ZIP_PATH}" "${DOWNLOAD_URL}"

# Extract ZIP
echo "📦 Extracting plugin to ${PLUGIN_ROOT} ..."
unzip -o "${ZIP_PATH}" -d "${PLUGIN_ROOT}" >/dev/null

# Fix filename if necessary
if [[ -f "${PLUGIN_ROOT}/terraform-backend-artifactory" ]]; then
    BIN_PATH="${PLUGIN_ROOT}/terraform-backend-artifactory"
else
    # Try to detect any executable
    CANDIDATE=$(find "${PLUGIN_ROOT}" -maxdepth 1 -type f -perm -u+x | head -n 1)
    if [[ -n "$CANDIDATE" ]]; then
        mv "$CANDIDATE" "${PLUGIN_ROOT}/terraform-backend-artifactory"
        BIN_PATH="${PLUGIN_ROOT}/terraform-backend-artifactory"
    else
        echo "❌ ERROR: Binary not found after extraction!"
        exit 1
    fi
fi

chmod +x "${BIN_PATH}"

# Cleanup temp directory
rm -rf "${TMP_DIR}"

echo ""
echo "=============================================="
echo "✅ Plugin installed successfully!"
echo " Location:"
echo "   ${BIN_PATH}"
echo ""
echo " Terraform plugin directory is now:"
echo "~/.terraform.d/plugins/registry.terraform.io/${NAMESPACE}/${NAME}/${VERSION}/${OS_ARCH}/"
echo "=============================================="
echo ""
echo "Next steps:"
echo "1) Ensure your Terraform block contains:"
echo "     terraform { backend \"artifactory\" {} }"
echo ""
echo "2) Add your backend.hcl file with repo, subpath, username, password."
echo ""
echo "3) Run:"
echo "     terraform init -backend-config=backend.hcl"
echo ""
