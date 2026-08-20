class Swarmdrop < Formula
  desc "SwarmDrop 命令行宿主：无账号、无公网 IP 的设备间端到端加密传输"
  homepage "https://github.com/swarm-apps/SwarmDrop"
  version "0.3.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/swarm-apps/SwarmDrop/releases/download/cli/swarmdrop-cli-v0.3.0/swarmdrop-cli-aarch64-apple-darwin.tar.xz"
      sha256 "1d32dc08ec07981483756d7dbe163b00d39b6e1710d7386607acb8b4d430577d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/swarm-apps/SwarmDrop/releases/download/cli/swarmdrop-cli-v0.3.0/swarmdrop-cli-x86_64-apple-darwin.tar.xz"
      sha256 "dfe25517af8aed0515445708fd3eb08c56c5b9dacacc0484521fb8e5f4e1e671"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/swarm-apps/SwarmDrop/releases/download/cli/swarmdrop-cli-v0.3.0/swarmdrop-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "e5adc7dd3e5ac83ee7a8e08207e2bf8f52d7f39cc2adaa2bde600b0908f9ff75"
    end
    if Hardware::CPU.intel?
      url "https://github.com/swarm-apps/SwarmDrop/releases/download/cli/swarmdrop-cli-v0.3.0/swarmdrop-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "6151b0c66977cd322ded86f87b286f7352533c768cf1969b833c60a80b1e8478"
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
