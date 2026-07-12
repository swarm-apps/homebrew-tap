class Swarmhive < Formula
  desc "SwarmHive CLI: local + CI/CD release entrypoint."
  homepage "https://github.com/swarm-apps/swarmhive"
  version "0.8.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/swarm-apps/swarmhive/releases/download/cli/v0.8.0/swarmhive-cli-aarch64-apple-darwin.tar.xz"
      sha256 "5ce3f0317a2b752e45354d03fc42f7dc2f6dd7807487e5283a9380e89f9aa79a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/swarm-apps/swarmhive/releases/download/cli/v0.8.0/swarmhive-cli-x86_64-apple-darwin.tar.xz"
      sha256 "cbad0ebb13905ab7b9b004c221b95daff453ed3b9796293bed758fe1df445db5"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/swarm-apps/swarmhive/releases/download/cli/v0.8.0/swarmhive-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "67bc89083a5a2aa232828be86aa8c8bd7ef81185a2a8797ef70cfc992a404692"
    end
    if Hardware::CPU.intel?
      url "https://github.com/swarm-apps/swarmhive/releases/download/cli/v0.8.0/swarmhive-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "2ecf2399cc43f000fdabad68f7ff3c59f3ef0c76d7fcb4916e5069240e54d05c"
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
