class Onyx < Formula
  @@version = "0.2.0"

  desc "Onyx CLI tool"
  homepage "https://github.com/onyx-hq/onyx"
  version @@version

  on_macos do
    if Hardware::CPU.intel?
      url "https://github.com/onyx-hq/onyx-public-releases/releases/download/#{@@version}/onyx-x86_64-apple-darwin"
      sha256 "36e1e45700a62e0e3ac7b5d885cb797d448a57a49e1107755a9a5414671d7001"
    elsif Hardware::CPU.arm?
      url "https://github.com/onyx-hq/onyx-public-releases/releases/download/#{@@version}/onyx-aarch64-apple-darwin"
      sha256 "2f11585cc1d9e78628db4ade1041cc436ec4d9990309e82ef434064497dcbb97"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/onyx-hq/onyx-public-releases/releases/download/#{@@version}/onyx-x86_64-unknown-linux-gnu"
      sha256 "9e3c0efcb92bcf0870b6f6dae1bb6015941e2206ef6e2510dcea07ece49a7a5f"
    elsif Hardware::CPU.arm?
      url "https://github.com/onyx-hq/onyx-public-releases/releases/download/#{@@version}/onyx-aarch64-unknown-linux-gnu"
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
