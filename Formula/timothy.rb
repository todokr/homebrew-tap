# frozen_string_literal: true

# This Formula belongs in todokr/homebrew-tap under Formula/timothy.rb.
# Update `url`, `sha256`, and `version` for each release. The GitHub Release
# body of timothy includes the exact values to paste.
class Timothy < Formula
  desc "Upload LLM-generated HTML and share via time-limited URLs"
  homepage "https://github.com/todokr/timothy"
  url "https://github.com/todokr/timothy/releases/download/v0.4.0/tim"
  sha256 "527627f9ea585fe1123674df18925077b53182aec6c02f69a6533584ded17e6f"
  version "0.4.0"
  license "EPL-2.0"

  depends_on "node"

  def install
    libexec.install "tim" => "tim.mjs"
    (bin/"tim").write <<~SH
      #!/bin/bash
      exec node "#{libexec}/tim.mjs" "$@"
    SH
    (bin/"tim").chmod 0755
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tim --version")
  end
end
