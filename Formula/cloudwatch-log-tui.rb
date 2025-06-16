class CloudwatchLogTui < Formula
  desc "Terminal UI for AWS CloudWatch Logs"
  homepage "https://github.com/ryutaro-asada/cloudwatch-log-tui"
  version "0.1.1"
  
  on_macos do
    if Hardware::CPU.intel?
      url "https://github.com/ryutaro-asada/cloudwatch-log-tui/releases/download/v#{version}/cloudwatch-log-tui-#{version}-darwin-amd64.tar.gz"
      sha256 "972e5ba5e30fe09d3224d338fcba7792bbe587a9545cf8eb269d60433942909a" # 実際のハッシュ値に置き換える
    else
      url "https://github.com/ryutaro-asada/cloudwatch-log-tui/releases/download/v#{version}/cloudwatch-log-tui-#{version}-darwin-arm64.tar.gz"
      sha256 "f999bff89be8060a0d265d6a9b44da2bcaa75a2df9cad80a31841e5ee1790419" # 実際のハッシュ値に置き換える
    end
  end
  
  on_linux do
    url "https://github.com/ryutaro-asada/cloudwatch-log-tui/releases/download/v#{version}/cloudwatch-log-tui-#{version}-linux-amd64.tar.gz"
    sha256 "ff3fe5c5d1cbc6d99eca85696c9420defede98962582bacaaf8305c737867932" # 実際のハッシュ値に置き換える
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
