class Onyx < Formula
  @@version = "0.1.1"

  desc "Onyx CLI tool"
  homepage "https://github.com/onyx-hq/onyx"
  version @@version

  on_macos do
    if Hardware::CPU.intel?
      url "https://github.com/onyx-hq/onyx/releases/download/#{@@version}/onyx-x86_64-apple-darwin"
      sha256 "93b08c93797ed00b3407323a398fa3d077d3ba3c2df23e7df1ba9def6535aff8"
    elsif Hardware::CPU.arm?
      url "https://github.com/onyx-hq/onyx/releases/download/#{@@version}/onyx-aarch64-apple-darwin"
      sha256 "e847fa8d1cb0435afcc17cf3ac32e88908258b20a059a67b67388fcde2914f0d"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/onyx-hq/onyx/releases/download/#{@@version}/onyx-x86_64-unknown-linux-gnu"
      sha256 "ddb17359dcaec0f8164f2a872906d97281153f06ca8cf6246a24a8a06023cea7"
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
