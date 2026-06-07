class Swarmhive < Formula
  desc "SwarmHive CLI: local + CI/CD release entrypoint."
  homepage "https://github.com/swarm-apps/swarmhive"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/swarm-apps/swarmhive/releases/download/cli/v0.2.0/swarmhive-cli-aarch64-apple-darwin.tar.xz"
      sha256 "6adfa8ee10dea46b8c1bb1de7cb6bfb34d85184647b35a014ce484a03b7c67de"
    end
    if Hardware::CPU.intel?
      url "https://github.com/swarm-apps/swarmhive/releases/download/cli/v0.2.0/swarmhive-cli-x86_64-apple-darwin.tar.xz"
      sha256 "a0cdf354694bac7d716062cbb0a7286d554bd478aa4318da53d348482c21890e"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/swarm-apps/swarmhive/releases/download/cli/v0.2.0/swarmhive-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "0c10e2bd3ac88fac1ced1686f6faaa5a6b23042047608b0a58970616096d99cd"
    end
    if Hardware::CPU.intel?
      url "https://github.com/swarm-apps/swarmhive/releases/download/cli/v0.2.0/swarmhive-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "3729a8cc9bfe243246ac1a3ad09d95543b8e07c0e7fa15faf7e36effd7b01799"
    end
  end
  license "Apache-2.0"

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
    bin.install "swarmhive" if OS.mac? && Hardware::CPU.arm?
    bin.install "swarmhive" if OS.mac? && Hardware::CPU.intel?
    bin.install "swarmhive" if OS.linux? && Hardware::CPU.arm?
    bin.install "swarmhive" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
