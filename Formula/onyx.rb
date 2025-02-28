class Onyx < Formula
  @@version = "0.1.0"

  desc "Onyx CLI tool"
  homepage "https://github.com/onyx-hq/onyx"
  version @@version

  on_macos do
    if Hardware::CPU.intel?
      url "https://github.com/onyx-hq/onyx/releases/download/#{@@version}/onyx-x86_64-apple-darwin"
      sha256 "8b5eb0121d9a7bfd3c1d7fae44dccad6e18de282f52f7bda7735c4872486f8fb"
    elsif Hardware::CPU.arm?
      url "https://github.com/onyx-hq/onyx/releases/download/#{@@version}/onyx-aarch64-apple-darwin"
      sha256 "108edbf361b78ea0c578824e1083b1fca4807e890ee33dc603de4c891fd7aab5"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/onyx-hq/onyx/releases/download/#{@@version}/onyx-x86_64-unknown-linux-gnu"
      sha256 "adcd065304fd715c69cc90585c5ea04cacbf1995d3c92af5964027ee38ddc1aa"
    elsif Hardware::CPU.arm?
      url "https://github.com/onyx-hq/onyx/releases/download/#{@@version}/onyx-aarch64-unknown-linux-gnu"
      sha256 "TBD"
    end
  end

  def install
    if OS.mac?
      if Hardware::CPU.intel?
        mv "onyx-x86_64-apple-darwin", "onyx"
      elsif Hardware::CPU.arm?
        mv "onyx-aarch64-apple-darwin", "onyx"
      end
    elsif OS.linux?
      if Hardware::CPU.intel?
        mv "onyx-x86_64-unknown-linux-gnu", "onyx"
      elsif Hardware::CPU.arm?
        mv "onyx-aarch64-unknown-linux-gnu", "onyx"
      end
    end
    bin.install "onyx"
  end

  test do
    system "#{bin}/onyx", "--version"
  end
end
