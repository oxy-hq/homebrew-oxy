class Onyx < Formula
  @@version = "0.1.39"

  desc "Onyx CLI tool"
  homepage "https://github.com/onyx-hq/onyx"
  version @@version

  on_macos do
    if Hardware::CPU.intel?
      url "https://github.com/onyx-hq/onyx-public-releases/releases/download/#{@@version}/onyx-x86_64-apple-darwin"
      sha256 "75e17be128abb3ac1b8c934b8b34bc7a292c2989fee0f0e1fae7f98777d58ae7"
    elsif Hardware::CPU.arm?
      url "https://github.com/onyx-hq/onyx-public-releases/releases/download/#{@@version}/onyx-aarch64-apple-darwin"
      sha256 "474751d5e9ff994f922fac3dd949e48a10051abe392610b7e3e1eeaffadf6cfe"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/onyx-hq/onyx-public-releases/releases/download/#{@@version}/onyx-x86_64-unknown-linux-gnu"
      sha256 "c5ff89dc03d07fbf708473f73c2484f9c3eaf1a75d56b3a96d5e84838e9902fb"
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
