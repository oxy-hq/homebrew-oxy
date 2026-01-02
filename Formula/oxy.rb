class Oxy < Formula
  @@version = "0.4.4"

  desc "oxy CLI tool"
  homepage "https://github.com/oxy-hq/oxy"
  version @@version

  SHA256_VALUES = {
    darwin_intel: "TBD",
    darwin_arm: "cac629f890aab605d23bd4a15a5bc29a641ce22c827be8a36c88dfda1c7c7525",
    linux_intel: "4edda531aab0231d09b682052fa5f537f3257e4a530cadf85a5cac343f7b0d19",
    linux_arm: "06bd77576566554e9d02774776d591582dfdeafa8e229003b41554e3159c266e"
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
