class Onyx < Formula
  desc "Onyx CLI tool"
  homepage "https://github.com/onyx-hq/onyx"
  version "0.1.36"

  on_macos do
    if Hardware::CPU.intel?
      url "https://github.com/onyx-hq/onyx-public-releases/releases/download/0.1.36/onyx-x86_64-apple-darwin"
      sha256 "8521e5a5cf07d7768d18d62464d1987a0fd0d3c55b886997e3a783ca61efc6ce"
    elsif Hardware::CPU.arm?
      url "https://github.com/onyx-hq/onyx-public-releases/releases/download/0.1.36/onyx-aarch64-apple-darwin"
      sha256 "d392235b1b4b48c6a19922207e312f1d0a3e5a0fff7d5d282ae082e06370dee8"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/onyx-hq/onyx-public-releases/releases/download/0.1.36/onyx-x86_64-unknown-linux-gnu"
      sha256 "TBD"
    elsif Hardware::CPU.arm?
      url "https://github.com/onyx-hq/onyx-public-releases/releases/download/0.1.36/onyx-aarch64-unknown-linux-gnu"
      sha256 "TBD"
    end
  end

  def install
    bin.install "onyx"
  end

  test do
    system "#{bin}/onyx", "--version"
  end
end
