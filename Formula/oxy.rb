class Oxy < Formula
  @@version = "0.3.17"

  desc "oxy CLI tool"
  homepage "https://github.com/oxy-hq/oxy"
  version @@version

  SHA256_VALUES = {
    darwin_intel: "2256f97422ffdf0282f82050ccbbbe47a5e7f567af7fb0d07192adbf739743ad",
    darwin_arm: "2d6a6c4bffe816433da68f0a724e4edb12dd1a5ca3fd171835a0072274dca67d",
    linux_intel: "d3307396e0a778bc22cbd7a389ec6d71c579c582010c15ca312f5c2e94f4ca01",
    linux_arm: "0f53bce775846023cd304163fa65e25e5e8f634588d3211b2f4d89b88c91f383"
  }

  on_macos do
    if Hardware::CPU.intel?
      url "https://github.com/oxy-hq/oxy/releases/download/#{@@version}/oxy-x86_64-apple-darwin"
      sha256 SHA256_VALUES[:darwin_intel]
    elsif Hardware::CPU.arm?
      url "https://github.com/oxy-hq/oxy/releases/download/#{@@version}/oxy-aarch64-apple-darwin"
      sha256 SHA256_VALUES[:darwin_arm]
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/oxy-hq/oxy/releases/download/#{@@version}/oxy-x86_64-unknown-linux-gnu"
      sha256 SHA256_VALUES[:linux_intel]
    elsif Hardware::CPU.arm?
      url "https://github.com/oxy-hq/oxy/releases/download/#{@@version}/oxy-aarch64-unknown-linux-gnu"
      sha256 SHA256_VALUES[:linux_arm]
    end
  end

  def install
    if OS.mac?
      if Hardware::CPU.intel?
        mv "oxy-x86_64-apple-darwin", "oxy"
      elsif Hardware::CPU.arm?
        mv "oxy-aarch64-apple-darwin", "oxy"
      end
    elsif OS.linux?
      if Hardware::CPU.intel?
        mv "oxy-x86_64-unknown-linux-gnu", "oxy"
      elsif Hardware::CPU.arm?
        mv "oxy-aarch64-unknown-linux-gnu", "oxy"
      end
    end
    bin.install "oxy"
  end

  test do
    system "#{bin}/oxy", "--version"
  end
end
