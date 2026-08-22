class Swarmdrop < Formula
  desc "SwarmDrop 命令行宿主：无账号、无公网 IP 的设备间端到端加密传输"
  homepage "https://github.com/swarm-apps/SwarmDrop"
  version "0.7.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/swarm-apps/SwarmDrop/releases/download/cli/swarmdrop-cli-v0.7.1/swarmdrop-cli-aarch64-apple-darwin.tar.xz"
      sha256 "82d533efa7adc04ed2920dab115f7fc728b2c00a67d751a9ce310a69962080e4"
    end
    if Hardware::CPU.intel?
      url "https://github.com/swarm-apps/SwarmDrop/releases/download/cli/swarmdrop-cli-v0.7.1/swarmdrop-cli-x86_64-apple-darwin.tar.xz"
      sha256 "7638b2ed19e22c490f3de1470a25fa8385bde8944a0c94e9b6cce94b029520e7"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/swarm-apps/SwarmDrop/releases/download/cli/swarmdrop-cli-v0.7.1/swarmdrop-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "3db95a378845af6f85efbfff264a54e235c24761ae3057c81cdf5abd0b041190"
    end
    if Hardware::CPU.intel?
      url "https://github.com/swarm-apps/SwarmDrop/releases/download/cli/swarmdrop-cli-v0.7.1/swarmdrop-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "43bee935b37053be6fd7be923c61b0cfb9bb2dad0e223db252cd971c1e4db838"
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
