class Swarmhive < Formula
  desc "SwarmHive CLI: local + CI/CD release entrypoint."
  homepage "https://github.com/swarm-apps/swarmhive"
  version "0.4.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/swarm-apps/swarmhive/releases/download/cli/v0.4.0/swarmhive-cli-aarch64-apple-darwin.tar.xz"
      sha256 "d460d2178d527b19c7bad8fa97319950c459d2b150875111e5f4294798fd7856"
    end
    if Hardware::CPU.intel?
      url "https://github.com/swarm-apps/swarmhive/releases/download/cli/v0.4.0/swarmhive-cli-x86_64-apple-darwin.tar.xz"
      sha256 "f40705cc9fcb7d9bdccd652f38dafdf7412262ecc368437a9054a42e2cdec65b"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/swarm-apps/swarmhive/releases/download/cli/v0.4.0/swarmhive-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "a7915259e8085af179854b0c2c1b35604c6a0d56451b45dfee3d404a633ee749"
    end
    if Hardware::CPU.intel?
      url "https://github.com/swarm-apps/swarmhive/releases/download/cli/v0.4.0/swarmhive-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "0233a289f6bc013e1224c1a041440204eadad250e65a5042316a0cc3dee0acde"
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
