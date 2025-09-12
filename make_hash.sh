#!/bin/bash

# バージョンの設定
VERSION="0.1.3"
BASE_URL="https://github.com/ryutaro-asada/cloudwatch-log-tui/releases/download/v${VERSION}"

# 各プラットフォーム用のSHA256ハッシュを計算
echo "Downloading and calculating SHA256 hashes..."

declare -A HASHES

for platform in "darwin-amd64" "darwin-arm64" "linux-amd64"; do
    filename="cloudwatch-log-tui-${VERSION}-${platform}.tar.gz"
    echo "Processing ${platform}..."
    curl -L "${BASE_URL}/${filename}" -o "${filename}" 2>/dev/null
    hash=$(shasum -a 256 "${filename}" | cut -d' ' -f1)
    HASHES[$platform]=$hash
    echo "${platform}: ${hash}"
    rm "${filename}"  # ダウンロードしたファイルを削除
done

echo ""
echo "Updating Formula/cloudwatch-log-tui.rb..."

# Rubyファイルを更新
cat > Formula/cloudwatch-log-tui.rb << EOF
class CloudwatchLogTui < Formula
  desc "Terminal UI for AWS CloudWatch Logs"
  homepage "https://github.com/ryutaro-asada/cloudwatch-log-tui"
  version "${VERSION}"
  
  on_macos do
    if Hardware::CPU.intel?
      url "https://github.com/ryutaro-asada/cloudwatch-log-tui/releases/download/v#{version}/cloudwatch-log-tui-#{version}-darwin-amd64.tar.gz"
      sha256 "${HASHES[darwin-amd64]}"
    else
      url "https://github.com/ryutaro-asada/cloudwatch-log-tui/releases/download/v#{version}/cloudwatch-log-tui-#{version}-darwin-arm64.tar.gz"
      sha256 "${HASHES[darwin-arm64]}"
    end
  end
  
  on_linux do
    url "https://github.com/ryutaro-asada/cloudwatch-log-tui/releases/download/v#{version}/cloudwatch-log-tui-#{version}-linux-amd64.tar.gz"
    sha256 "${HASHES[linux-amd64]}"
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
echo ""
echo "Updated values:"
echo "  Version: ${VERSION}"
echo "  darwin-amd64 SHA256: ${HASHES[darwin-amd64]}"
echo "  darwin-arm64 SHA256: ${HASHES[darwin-arm64]}"
echo "  linux-amd64 SHA256: ${HASHES[linux-amd64]}"
