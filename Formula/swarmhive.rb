class Swarmhive < Formula
  desc "SwarmHive CLI: local + CI/CD release entrypoint."
  homepage "https://github.com/swarm-apps/swarmhive"
  version "0.3.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/swarm-apps/swarmhive/releases/download/cli/v0.3.0/swarmhive-cli-aarch64-apple-darwin.tar.xz"
      sha256 "7be47a6671e0949bbdfed7c4eaf0f499dcab6a72b775a822a9c8a3be351168ed"
    end
    if Hardware::CPU.intel?
      url "https://github.com/swarm-apps/swarmhive/releases/download/cli/v0.3.0/swarmhive-cli-x86_64-apple-darwin.tar.xz"
      sha256 "c8075960f3f35341233805a6180e5916a969b009079305fd975c31e14f42e965"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/swarm-apps/swarmhive/releases/download/cli/v0.3.0/swarmhive-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "28a53e3cad75d8223bf4cb896f2af1419694add20a946f9eb1b28cbbd3b8d21f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/swarm-apps/swarmhive/releases/download/cli/v0.3.0/swarmhive-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "0980652145db04a832b64aceaeedd4cf9574c3ceed4993d41c003bc2885bfe1b"
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
