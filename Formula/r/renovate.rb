require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-37.301.0.tgz"
  sha256 "19697f17f63f6152da9a18c16e604f97544606178a0ba55e40d48eb9825b2c96"
  license "AGPL-3.0-only"

  # There are thousands of renovate releases on npm and the page the `Npm`
  # strategy checks is several MB in size and can time out before the request
  # resolves. This checks the first page of tags on GitHub (to minimize data
  # transfer).
  livecheck do
    url "https://github.com/renovatebot/renovate/tags"
    regex(%r{href=["']?[^"' >]*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
    strategy :page_match
    throttle 10
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f628587d81fc813746d7355e96a3c5319671ae524af811a575b89acc08504b4b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e62f4a682e58ed6f92258df75889ad48a67890c859078262aadfae09e5975d15"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ede44ea99d93d4d984991f3639c542ce6c8e8c7963e5457b5ddf53fb4d5f04b6"
    sha256 cellar: :any_skip_relocation, sonoma:         "5ced6fe6f7cc0862fc8c2267b4eb11c3bef1d61c53d49dc1597cfae5c4ddce09"
    sha256 cellar: :any_skip_relocation, ventura:        "bb4114235d7fa07246c409b9d251dce65f08d13082b286e3546e4dfa97a1f6ad"
    sha256 cellar: :any_skip_relocation, monterey:       "5cf521447abe7feb7f5c53e6f5d0748c81e9b87448073f0ad5ca5166322ed6b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1eab1713aadfa01a1bd5f076089f72b9e356184a97b3618bf2f3bb8a9134557f"
  end

  depends_on "node"

  uses_from_macos "git", since: :monterey

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "FATAL: You must configure a GitHub token", shell_output("#{bin}/renovate 2>&1", 1)
  end
end
