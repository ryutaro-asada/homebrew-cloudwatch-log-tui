#!/bin/bash
VERSION="0.1.0"
BASE_URL="https://github.com/ryutaro-asada/cloudwatch-log-tui/releases/download/v${VERSION}"

for platform in "darwin-amd64" "darwin-arm64" "linux-amd64"; do
  filename="cloudwatch-log-tui-${VERSION}-${platform}.tar.gz"
  curl -L "${BASE_URL}/${filename}" -o "${filename}"
  echo -n "${platform}: "
  shasum -a 256 "${filename}" | cut -d' ' -f1
done
