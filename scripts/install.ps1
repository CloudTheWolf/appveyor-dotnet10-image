#!/usr/bin/env bash
set -e

echo "=== Installing Latest .NET 10 for Linux ==="

# Path to install
DOTNET_ROOT="/usr/share/dotnet"
mkdir -p "$DOTNET_ROOT"

# Get latest SDK version automatically from Microsoft JSON feed
LATEST_SDK=$(curl -s https://dotnetcli.blob.core.windows.net/dotnet/release-metadata/10.0/releases.json \
  | jq -r '.latest-release')

echo "Latest .NET 10 SDK: $LATEST_SDK"

# Construct download URL
SDK_URL="https://download.visualstudio.microsoft.com/download/pr/dotnet-sdk-${LATEST_SDK}-linux-x64.tar.gz"

echo "Downloading from: $SDK_URL"

wget -O dotnet.tar.gz "$SDK_URL"

echo "Extracting .NET 10 SDK..."
tar -xzf dotnet.tar.gz -C "$DOTNET_ROOT"

# Add to PATH system-wide
echo "export DOTNET_ROOT=${DOTNET_ROOT}" >> /etc/profile.d/dotnet10.sh
echo "export PATH=\$PATH:${DOTNET_ROOT}" >> /etc/profile.d/dotnet10.sh
chmod +x /etc/profile.d/dotnet10.sh

# Verify installation
echo "=== Verifying installation ==="
export DOTNET_ROOT=${DOTNET_ROOT}
export PATH=$PATH:${DOTNET_ROOT}

dotnet --info

echo "=== .NET 10 Installed Successfully ==="
