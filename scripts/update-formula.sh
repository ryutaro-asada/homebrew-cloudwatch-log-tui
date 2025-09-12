#!/bin/bash
set -euo pipefail

# スクリプトの使い方を表示
usage() {
	echo "Usage: $0 <version>"
	echo "  version: Version number without 'v' prefix (e.g., 0.1.3)"
	exit 1
}

# 引数チェック
if [ $# -ne 1 ]; then
	usage
fi

VERSION="$1"
BASE_URL="https://github.com/ryutaro-asada/cloudwatch-log-tui/releases/download/v${VERSION}"

echo "Updating Formula to version ${VERSION}..."

# 一時ディレクトリを作成
TEMP_DIR=$(mktemp -d)
trap "rm -rf ${TEMP_DIR}" EXIT

# 各プラットフォーム用のSHA256ハッシュを計算
declare -A HASHES

for platform in "darwin-amd64" "darwin-arm64" "linux-amd64"; do
	filename="cloudwatch-log-tui-${VERSION}-${platform}.tar.gz"
	echo "Processing ${platform}..."

	# リトライ付きダウンロード
	for attempt in {1..3}; do
		if curl -L "${BASE_URL}/${filename}" -o "${TEMP_DIR}/${filename}" 2>/dev/null; then
			hash=$(shasum -a 256 "${TEMP_DIR}/${filename}" | cut -d' ' -f1)
			HASHES[$platform]=$hash
			echo "  SHA256: ${hash}"
			break
		else
			echo "  Download attempt ${attempt}/3 failed"
			if [ $attempt -eq 3 ]; then
				echo "ERROR: Failed to download ${filename}"
				exit 1
			fi
			sleep 2
		fi
	done
done

# Formulaファイルを生成
cat >Formula/cloudwatch-log-tui.rb <<EOF
class CloudwatchLogTui < Formula
  desc "Terminal UI for AWS CloudWatch Logs"
  homepage "https://github.com/ryutaro-asada/cloudwatch-log-tui"
  version "${VERSION}"
  
  on_macos do
    if Hardware::CPU.intel?
      url "https://github.com/ryutaro-asada/cloudwatch-log-tui/releases/download/v#{version}/cloudwatch-log-tui-#{version}-darwin-amd64.tar.gz"
      sha256 "${HASHES[darwin - amd64]}"
    else
      url "https://github.com/ryutaro-asada/cloudwatch-log-tui/releases/download/v#{version}/cloudwatch-log-tui-#{version}-darwin-arm64.tar.gz"
      sha256 "${HASHES[darwin - arm64]}"
    end
  end
  
  on_linux do
    url "https://github.com/ryutaro-asada/cloudwatch-log-tui/releases/download/v#{version}/cloudwatch-log-tui-#{version}-linux-amd64.tar.gz"
    sha256 "${HASHES[linux - amd64]}"
  end

  def install
    binary_name = "cloudwatch-log-tui-#{version}-#{os}-#{arch}"
    bin.install binary_name => "cloudwatch-log-tui"
  end

  def os
    OS.mac? ? "darwin" : "linux"
  end

  def arch
    case Hardware::CPU.arch
    when :x86_64
      "amd64"
    when :arm64
      "arm64"
    else
      Hardware::CPU.arch
    end
  end

  test do
    system "#{bin}/cloudwatch-log-tui", "--version"
  end
end
EOF

echo "Formula updated successfully!"
echo "Summary:"
echo "  Version: ${VERSION}"
echo "  darwin-amd64: ${HASHES[darwin - amd64]}"
echo "  darwin-arm64: ${HASHES[darwin - arm64]}"
echo "  linux-amd64:  ${HASHES[linux - amd64]}"
