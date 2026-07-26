class Genie < Formula
  desc "A command line shell for using LLMs tools in the command line"
  homepage "https://github.com/grahambrooks/genie"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/grahambrooks/genie/archive/refs/tags/v0.4.tar.gz"
      sha256 "1de3dc092750e62fa9a05fab983537dfd375f2c130c3ac9e96232acd80a47f12"
    end
    if Hardware::CPU.intel?
      url "https://github.com/grahambrooks/genie/releases/download/0.2.0/genie-x86_64-apple-darwin.tar.xz"
      sha256 "a64e747f3f31e8b1f588fdd112bfe22fc5fdde0da10d58be24c51e1a1af3d89d"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/grahambrooks/genie/releases/download/0.2.0/genie-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "12446c2d99d1d3be9fcab92f33c50085cc1425afa8a85fa9258ef6f2337a35a2"
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":     {},
    "x86_64-apple-darwin":      {},
    "x86_64-unknown-linux-gnu": {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "genie" if OS.mac? && Hardware::CPU.arm?
    bin.install "genie" if OS.mac? && Hardware::CPU.intel?
    bin.install "genie" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
