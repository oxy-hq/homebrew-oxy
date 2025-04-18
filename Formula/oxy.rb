class Oxy < Formula
  @@version = "0.1.17"

  desc "oxy CLI tool"
  homepage "https://github.com/oxy-hq/oxy"
  version @@version

  SHA256_VALUES = {
    darwin_intel: "ac3df273f20ffc729e3ff625ff30afb4fed387aa8e8e9c8548b8a851a877411a",
    darwin_arm: "8e658bdf601b68c331041012fc2e8f581f853a7fd2a00ad2a0fe207da9d89762",
    linux_intel: "738765c51323415fd5804e74db6b9a52df03787a8ca3c867af274b305d14112b",
    linux_arm: "ba76e14b04f20d452007a541963f8745b89c4f84e8fcc943e4bcb97440585655"
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
