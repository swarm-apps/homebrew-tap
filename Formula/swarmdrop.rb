class Swarmdrop < Formula
  desc "SwarmDrop 命令行宿主：无账号、无公网 IP 的设备间端到端加密传输"
  homepage "https://github.com/swarm-apps/SwarmDrop"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/swarm-apps/SwarmDrop/releases/download/cli/v0.1.0/swarmdrop-cli-aarch64-apple-darwin.tar.xz"
      sha256 "8e3caf6924108f6dad8ec09b8835af18e110dc01ef6aa86ee8cf286408dc6b53"
    end
    if Hardware::CPU.intel?
      url "https://github.com/swarm-apps/SwarmDrop/releases/download/cli/v0.1.0/swarmdrop-cli-x86_64-apple-darwin.tar.xz"
      sha256 "29f52e3f5dd1ec51fd3d1e367198c5cd4c32f63771aaa4547c999ba5d0f73752"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/swarm-apps/SwarmDrop/releases/download/cli/v0.1.0/swarmdrop-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "dfa8ea5a56f71ad1be3bd60087ccf05ea8d96e80a05d04571a124e790232c886"
    end
    if Hardware::CPU.intel?
      url "https://github.com/swarm-apps/SwarmDrop/releases/download/cli/v0.1.0/swarmdrop-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "ba07bb64e69abbbf4608e5d02e521dbdccf19daf452a097f3216f51872d24841"
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
