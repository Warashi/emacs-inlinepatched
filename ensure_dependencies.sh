#!/bin/bash
set -euo pipefail
OS_VERSION="$(sw_vers -productVersion | cut -f '1,2' -d '.')"
sudo installer -pkg "/Library/Developer/CommandLineTools/Packages/macOS_SDK_headers_for_macOS_${OS_VERSION}.pkg" -target /
brew install autoconf automake gnu-sed texinfo pkg-config gnutls
