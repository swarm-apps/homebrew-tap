class Swarmdrop < Formula
  desc "SwarmDrop 命令行宿主：无账号、无公网 IP 的设备间端到端加密传输"
  homepage "https://github.com/swarm-apps/SwarmDrop"
  version "0.7.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/swarm-apps/SwarmDrop/releases/download/cli/swarmdrop-cli-v0.7.0/swarmdrop-cli-aarch64-apple-darwin.tar.xz"
      sha256 "207c88414a5771d8bbdaa210904ca34ec876a1abc322def137490758e619074a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/swarm-apps/SwarmDrop/releases/download/cli/swarmdrop-cli-v0.7.0/swarmdrop-cli-x86_64-apple-darwin.tar.xz"
      sha256 "75237d7b9061bc2ad74bc09a5ecc366c5fe12af7e0948efdc562d226cb1703ae"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/swarm-apps/SwarmDrop/releases/download/cli/swarmdrop-cli-v0.7.0/swarmdrop-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "bfaf3e657861d901a63de656cac5c06ef0c2de415c2ac37d0d39adb0002cd953"
    end
    if Hardware::CPU.intel?
      url "https://github.com/swarm-apps/SwarmDrop/releases/download/cli/swarmdrop-cli-v0.7.0/swarmdrop-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "5412118f8c419f29d311a0c91fa100ca15f487c88903d8085b6f5a7d1934044b"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":              {},
    "aarch64-unknown-linux-gnu":         {},
    "x86_64-apple-darwin":               {},
    "x86_64-pc-windows-gnu":             {},
    "x86_64-unknown-linux-gnu":          {},
    "x86_64-unknown-linux-musl-dynamic": {},
    "x86_64-unknown-linux-musl-static":  {},
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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "swarmdrop"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "swarmdrop"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "swarmdrop"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "swarmdrop"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
