class CloudwatchLogTui < Formula
  desc "Terminal UI for AWS CloudWatch Logs"
  homepage "https://github.com/ryutaro-asada/cloudwatch-log-tui"
  version "0.1.2"
  
  on_macos do
    if Hardware::CPU.intel?
      url "https://github.com/ryutaro-asada/cloudwatch-log-tui/releases/download/v#{version}/cloudwatch-log-tui-#{version}-darwin-amd64.tar.gz"
      sha256 "8d453877f18e3307dee1a1bf229f5e1f84e0eab2dfa6e451a7ac1f7ab77a353b" # 実際のハッシュ値に置き換える
    else
      url "https://github.com/ryutaro-asada/cloudwatch-log-tui/releases/download/v#{version}/cloudwatch-log-tui-#{version}-darwin-arm64.tar.gz"
      sha256 "b5c0cd84d7f4f03cd353fa7789fdb9dc86d4ecfb3155b3d0df2583e556aef194" # 実際のハッシュ値に置き換える
    end
  end
  
  on_linux do
    url "https://github.com/ryutaro-asada/cloudwatch-log-tui/releases/download/v#{version}/cloudwatch-log-tui-#{version}-linux-amd64.tar.gz"
    sha256 "221b54b2ec98d5951f4714967a4701070653a88f084a974b9606a1d5fc4f6e16" # 実際のハッシュ値に置き換える
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
