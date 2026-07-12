class Swarmhive < Formula
  desc "SwarmHive CLI: local + CI/CD release entrypoint."
  homepage "https://github.com/swarm-apps/swarmhive"
  version "0.7.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/swarm-apps/swarmhive/releases/download/cli/v0.7.0/swarmhive-cli-aarch64-apple-darwin.tar.xz"
      sha256 "2fda2f3f9c8f9c4e82aadaf8afb6ad1c92e58c0496145067862a74f0290279e3"
    end
    if Hardware::CPU.intel?
      url "https://github.com/swarm-apps/swarmhive/releases/download/cli/v0.7.0/swarmhive-cli-x86_64-apple-darwin.tar.xz"
      sha256 "f0288daddcc3d5ebf585cd6e11fd720889cdc28e5a5e1a0a5ae8cee8ec3b743d"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/swarm-apps/swarmhive/releases/download/cli/v0.7.0/swarmhive-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "927d96b3dbf97b84bad50252131b875df4627c699e8c3c88696c7a586c5ef78b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/swarm-apps/swarmhive/releases/download/cli/v0.7.0/swarmhive-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "830a5e17568c13465945396a01fc5289913dcfdd23b4d825e0692f417e22860e"
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
