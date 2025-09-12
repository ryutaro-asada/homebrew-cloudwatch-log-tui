class CloudwatchLogTui < Formula
  desc "Terminal UI for AWS CloudWatch Logs"
  homepage "https://github.com/ryutaro-asada/cloudwatch-log-tui"
  version "0.1.3"
  
  on_macos do
    if Hardware::CPU.intel?
      url "https://github.com/ryutaro-asada/cloudwatch-log-tui/releases/download/v#{version}/cloudwatch-log-tui-#{version}-darwin-amd64.tar.gz"
      sha256 "871836ceb9c0b991e7d33f0124d43d0f467895acc0607529f2d17a4f39b64680"
    else
      url "https://github.com/ryutaro-asada/cloudwatch-log-tui/releases/download/v#{version}/cloudwatch-log-tui-#{version}-darwin-arm64.tar.gz"
      sha256 "c689b12e81ed64ca16d071da9cbc1b2e52f701eaf06369188215bb486ab7bf31"
    end
  end
  
  on_linux do
    url "https://github.com/ryutaro-asada/cloudwatch-log-tui/releases/download/v#{version}/cloudwatch-log-tui-#{version}-linux-amd64.tar.gz"
    sha256 "981f7205d37c069993134b54a79500600a47572cedbf7f7b0b55d10ff4f2c390"
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
