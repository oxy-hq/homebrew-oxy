class Oxy < Formula
  @@version = "0.1.9"

  desc "oxy CLI tool"
  homepage "https://github.com/oxy-hq/oxy"
  version @@version

  SHA256_VALUES = {
    darwin_intel: "cd5fec30c0e10664e22f51d31b7abdafabb5db41c3ca0d3c2c5df49633181f10",
    darwin_arm: "43d05724a8f6277975087e62bb4e0c1e6b9341012e717ffa09f5bc960c8c7bff",
    linux_intel: "cf6c6c7b3d9da76b6d3adb06970cca139260683a24e31ef3b6e82d8f693bc85f",
    linux_arm: "TBD"
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
