#!/bin/bash
set -euo pipefail

VERSION="${1:-}"

if [ -z "${VERSION}" ]; then
	echo "Usage: $0 <version>"
	exit 1
fi

cat <<EOF
## 🔄 Auto-update cloudwatch-log-tui Formula

This PR updates the cloudwatch-log-tui Formula to version **${VERSION}**.

### Changes
- Updated version number from $(grep 'version "' Formula/cloudwatch-log-tui.rb | sed 's/.*version "\(.*\)"/\1/') to ${VERSION}
- Updated SHA256 hashes for all platforms

### Release Notes
Check the [release page](https://github.com/ryutaro-asada/cloudwatch-log-tui/releases/tag/v${VERSION}) for details.

### Testing
After merging, test the installation:
\`\`\`bash
brew update
brew upgrade cloudwatch-log-tui
# or for new installation
brew install cloudwatch-log-tui
\`\`\`

---
*This PR was automatically created by GitHub Actions*
EOF
