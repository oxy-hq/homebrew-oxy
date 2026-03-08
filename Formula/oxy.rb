class Oxy < Formula
  @@version = "0.5.23"

  desc "oxy CLI tool"
  homepage "https://github.com/oxy-hq/oxy"
  version @@version

  SHA256_VALUES = {
    darwin_intel: "TBD",
    darwin_arm: "4c293e26ae3b7bbe5a266c986d6cf193c47b3dbb38c6043da6ad985967dbeb36",
    linux_intel: "d62ed96fdcc030ce8cfe8c6a213a8da182299af4aae6666e8c8133633125ccd3",
    linux_arm: "00b940559534d5eb6b67ed00d2fc3afdc3fb26ddfdb66ecf58365aa03ea293f9"
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
