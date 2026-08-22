class Swarmdrop < Formula
  desc "SwarmDrop 命令行宿主：无账号、无公网 IP 的设备间端到端加密传输"
  homepage "https://github.com/swarm-apps/SwarmDrop"
  version "0.9.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/swarm-apps/SwarmDrop/releases/download/cli/swarmdrop-cli-v0.9.0/swarmdrop-cli-aarch64-apple-darwin.tar.xz"
      sha256 "17503b94bf9defb22c0ccc943169b0013204b7733b7cd36e5b8a71f38dea92e4"
    end
    if Hardware::CPU.intel?
      url "https://github.com/swarm-apps/SwarmDrop/releases/download/cli/swarmdrop-cli-v0.9.0/swarmdrop-cli-x86_64-apple-darwin.tar.xz"
      sha256 "386ea536c0aa36e3ef1e87efafce03b662b55cc05774d1035271b55dcf75d0b6"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/swarm-apps/SwarmDrop/releases/download/cli/swarmdrop-cli-v0.9.0/swarmdrop-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "ecc44fd1adfe5f3e60d19d7ed720862a724d95f8f787a13d923106d95bbf9ae2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/swarm-apps/SwarmDrop/releases/download/cli/swarmdrop-cli-v0.9.0/swarmdrop-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "d14ff39a0f37393eca3ef45ce88c9a843ee8c81a2fb6137af1f7466d01c7ff86"
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
